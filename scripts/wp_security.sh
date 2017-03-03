#/bin/bash
# --- Install & Configure WP
su www-data -c "
#
wp --path=/var/www/html/ plugin install wp-simple-firewall --activate
#wp --path=/var/www/html/ option update varnish_caching_enable 1 || wp --path=/var/www/html/ option add varnish_caching_enable 1
#
#
#wp --path=/var/www/html/ plugin update --all
#wp --path=/var/www/html/ theme update --all
#wp --path=/var/www/html/ core update
#wp --path=/var/www/html/ core update-db
"
# icwp_wpsf_block_send_email_address
# option_section_icwp_wpsf_block_wordpress_terms
# option_section_icwp_wpsf_block_php_code
# option_section_icwp_wpsf_block_aggressive
# option_section_icwp_wpsf_block_send_email
# option_section_icwp_wpsf_enable_login_protect
# option_section_icwp_wpsf_enable_email_authentication\
# icwp_wpsf_rename_wplogin_path
# option_section_icwp_wpsf_enable_xmlrpc_compatibility
# option_section_icwp_wpsf_enable_autoupdate_themes
# option_section_icwp_wpsf_enable_autoupdate_plugins
# icwp_wpsf_enable_upgrade_notification_email
# icwp_wpsf_override_email_address
# option_section_icwp_wpsf_enable_ips
# option_section_icwp_wpsf_block_exe_file_uploads
