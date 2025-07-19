# frozen_string_literal: true
class CatalogController < ApplicationController

  include Blacklight::Catalog

  configure_blacklight do |config|
    config.view.gallery(document_component: Blacklight::Gallery::DocumentComponent, icon: Blacklight::Gallery::Icons::GalleryComponent)
    config.show.tile_source_field = :content_metadata_image_iiif_info_ssm
    config.show.partials.insert(1, :openseadragon)

    #config.view.gallery(document_component: Blacklight::Gallery::DocumentComponent)

    # disable these three document action until we have resources to configure them to work
    config.show.document_actions.delete(:citation)
    config.show.document_actions.delete(:sms)
    config.show.document_actions.delete(:email)

    # config.add_results_document_tool(:bookmark, partial: 'bookmark_control', if: :render_bookmarks_control?)

    config.add_results_collection_tool(:sort_widget)
    config.add_results_collection_tool(:per_page_widget)
    config.add_results_collection_tool(:view_type_group)

    # config.add_show_tools_partial(:bookmark, partial: 'bookmark_control', if: :render_bookmarks_control?)
    # config.add_nav_action(:bookmark, partial: 'blacklight/nav/bookmark', if: :render_bookmarks_control?)
    config.add_nav_action(:search_history, partial: 'blacklight/nav/search_history')

    # solr path which will be added to solr base url before the other solr params.
    config.solr_path = 'select'
    config.document_solr_path = 'select'

    # items to show per page, each number in the array represent another option to choose from.
    config.per_page = [80,160,240,1000]

    config.default_facet_limit = 10

    ## Class for sending and receiving requests from a search index
    # config.repository_class = Blacklight::Solr::Repository
    #
    ## Class for converting Blacklight's url parameters to into request parameters for the search index
    # config.search_builder_class = ::SearchBuilder
    #
    ## Model that maps search index responses to the blacklight response model
    # config.response_model = Blacklight::Solr::Response

    ## Default parameters to send to solr for all search-like requests. See also SearchBuilder#processed_parameters
    #
    # customizations to support existing Solr cores
    config.default_solr_params = {
        'rows': 12,
        'facet.mincount': 1,
        'q.alt': '*:*',
        'defType': 'edismax',
        'df': 'text',
        'q.op': 'AND',
        'q.fl': '*,score'
    }

    # solr path which will be added to solr base url before the other solr params.
    # config.solr_path = 'select'

    ## Default parameters to send on single-document requests to Solr. These settings are the Blackligt defaults (see SearchHelper#solr_doc_params) or
    ## parameters included in the Blacklight-jetty document requestHandler.
    #
    config.default_document_solr_params = {
        qt: 'document',
        #  ## These are hard-coded in the blacklight 'document' requestHandler
        #  # fl: '*',
        #  # rows: 1,
        # this is needed for our Solr services
        q: '{!term f=id v=$id}'
    }

    # solr field configuration for search results/index views
    # list of images is hardcoded for both index and show displays
    #{index_title}
    config.index.thumbnail_field = 'path_ss'

    # solr field configuration for document/show views
    #{show_title}
    config.show.thumbnail_field = 'path_ss'

    # Have BL send all facet field names to Solr, which has been the default
    # previously. Simply remove these lines if you'd rather use Solr request
    # handler defaults, or have no facets.
    config.add_facet_fields_to_solr_request!

    # use existing "catchall" field called text
    # config.add_search_field 'text', label: 'Any field'
    config.spell_max = 5

    # SEARCH FIELDS
    config.add_search_field 'text', label: 'Any field'

    [
      ['year_txt', 'Year'],
      ['lockenumber_txt', 'Locke number'],
      ['location_txt', 'Location']
      ].each do |search_field|
      config.add_search_field(search_field[0]) do |field|
        field.label = search_field[1]
        #field.solr_parameters = { :'spellcheck.dictionary' => search_field[0] }
        field.solr_parameters = {
          qf: search_field[0],
          pf: search_field[0],
          op: 'AND'
        }
      end
    end

    # Configuration for autocomplete suggestor
    config.autocomplete_enabled = false
    config.autocomplete_path = 'suggest'

    # FACET FIELDS
     config.add_facet_field 'top_s', label: 'Top level', limit: true
     config.add_facet_field 'sub_s', label: '2nd level', limit: true
     config.add_facet_field 'city_s', label: 'City', limit: true
     config.add_facet_field 'lockenumber_s', label: 'Locke number', limit: true
     config.add_facet_field 'location_s', label: 'Location', limit: true
     config.add_facet_field 'year_s', label: 'Year', limit: true

    # INDEX DISPLAY
     config.add_index_field 'top_s', label: 'Top level'
     config.add_index_field 'sub_s', label: '2nd level'
     config.add_index_field 'city_s', label: 'City'
     config.add_index_field 'lockenumber_s', label: 'Locke number'
     config.add_index_field 'location_s', label: 'Location'
     config.add_index_field 'path_s', helper_method: 'render_image_link', label: 'MEDIA'
     # config.add_index_field 'path_s', label: 'IMAGENAME'


    # SHOW DISPLAY
     config.add_show_field 'lockenumber_s', label: 'Locke number'
     config.add_show_field 'path_ss', helper_method: 'render_images', label: 'Images'


    # SORT FIELDS
    config.add_sort_field 'year_s asc, lockenumber_s asc', label: 'Year, Locke number'

    # TITLE
    config.index.title_field = 'title_s'
    config.show.title_field = 'title_s'

  end
end
