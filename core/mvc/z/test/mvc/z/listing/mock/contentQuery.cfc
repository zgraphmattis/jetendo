<cfcomponent>
<cffunction name="getContentQuery" localmode="modern" access="public">
<cfscript>
return queryNew("content_id,content_text,content_summary,content_metakey,content_metadesc,content_name,content_name2,content_unique_name,content_no_publish,content_group_id,content_parent_id,content_locked,content_no_text,content_price,content_mls_price,content_address,content_created_datetime,content_updated_datetime,content_on_sidebar,content_photo,content_thumbnail,content_sort,content_datetime,content_hide_link,content_only_summary,content_file,content_file_caption,content_thumbnail2,content_photo2,content_image_caption2,content_image_caption,content_image_url2,content_image_url,content_child_group_id,content_url_only,content_file_link_text,content_show_site_map,content_user_group_access,content_html_text,content_hide_modal,content_flash_id,content_for_sale,content_deleted,content_models,content_mls_provider,content_mls_number,content_mls_override,content_city,content_search_mls,content_home_page,content_photo_hide_image,content_include_listings,content_property_type_id,content_search,content_force_featured_id,content_created_user_id,content_child_sorting,content_mix_sold,content_user_group_id,content_hide_global,content_firm_name,content_engine_name,property_id,content_virtual_tour,content_template,content_lot_number,content_oldid,content_listing_user_id,content_text_position,content_price_update_datetime,content_latitude,content_longitude,content_property_bedrooms,content_property_bathrooms,content_property_half_baths,content_property_sqfoot,content_property_city,content_property_state,content_property_country,content_property_zip,content_property_enable_rates,content_property_enable_calendar,content_property_enable_reservation,content_is_listing,content_property_template,content_diagonal_message,content_slideshow_id,content_image_list,content_menu_title,content_disable_contact_links,content_image_library_id,content_image_library_layout,content_subpage_link_layout,content_parentpage_link_layout,content_featured_listing_parent_page,content_show_map,site_id,content_metatitle,content_metacode,content_saved_search_id,content_site_option_app_id,content_html_text_bottom,content_system_url", "INTEGER,LONGVARCHAR,LONGVARCHAR,LONGVARCHAR,LONGVARCHAR,VARCHAR,VARCHAR,VARCHAR,CHAR,INTEGER,INTEGER,CHAR,CHAR,DECIMAL,CHAR,VARCHAR,TIMESTAMP,TIMESTAMP,CHAR,VARCHAR,VARCHAR,INTEGER,TIMESTAMP,CHAR,CHAR,VARCHAR,VARCHAR,VARCHAR,VARCHAR,VARCHAR,VARCHAR,VARCHAR,VARCHAR,INTEGER,LONGVARCHAR,VARCHAR,CHAR,CHAR,LONGVARCHAR,CHAR,INTEGER,CHAR,CHAR,LONGVARCHAR,INTEGER,VARCHAR,CHAR,VARCHAR,CHAR,CHAR,CHAR,VARCHAR,INTEGER,VARCHAR,INTEGER,INTEGER,CHAR,CHAR,INTEGER,CHAR,VARCHAR,VARCHAR,VARCHAR,VARCHAR,VARCHAR,INTEGER,INTEGER,INTEGER,CHAR,TIMESTAMP,VARCHAR,VARCHAR,INTEGER,INTEGER,INTEGER,VARCHAR,VARCHAR,CHAR,CHAR,VARCHAR,CHAR,CHAR,CHAR,CHAR,INTEGER,VARCHAR,INTEGER,LONGVARCHAR,VARCHAR,CHAR,INTEGER,INTEGER,INTEGER,INTEGER,CHAR,CHAR,INTEGER,VARCHAR,LONGVARCHAR,INTEGER,INTEGER,CHAR,CHAR", [["6991", "<p>Testing body content here.</p>", "", "Test custom listing 1", "Testing body content here.", "Test custom listing 1", "", "", "0", "0", "3064", "0", "0", "57000", "1", "Address", "{ts '2012-10-18 13:42:03'}", "{ts '2013-01-27 15:09:19'}", "0", "", "558952_1.jpg", "1", "", "0", "0", "", "", "", "", "", "", "", "", "0", "", "", "1", "0", "", "0", "0", "1", "0", "", "4", "4-522906", "1", "", "0", "0", "0", "", "0", "test", "0", "0", "0", "0", "0", "0", "", "", "", "", "", "0", "0", "0", "0", "{ts '2012-12-30 14:00:00'}", "29.1790166", "-81.0041061", "2", "3", "1", "", "618", "FL", "", "32176", "0", "0", "0", "1", "1", "", "0", "", "", "1", "655", "0", "0", "7", "0", "0", "61", "", "", "0", "43", "0", "0"]]);
</cfscript>
</cffunction>
</cfcomponent>