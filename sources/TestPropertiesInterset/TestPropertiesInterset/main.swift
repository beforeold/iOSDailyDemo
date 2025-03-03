import Foundation

let codeSet: Set = [
  "action", "amount", "app_start_pos", "code", "count", "duration", "elapsed", "error", "error_count", "gender", "lang",
  "msg", "network_country_iso", "notification_auth_status", "notification_id", "order_id", "photo_count", "photo_url",
  "position_source", "progress_count", "progress_id", "receipt", "shoot_count", "sku", "status", "style_id",
  "style_name", "ratio", "image_number", "success", "time_left", "title", "$url", "url", "origin_url", "hd_url",
  "version_code", "index", "product_id", "transaction_id", "style_id_list", "last_order_status", "style_id_count",
  "create_type", "push_campaign_id", "push_id", "trigger_tag", "is_subscribed", "is_free", "is_discount_code", "from",
  "history_selected_photo_count", "price", "purchase_type", "length", "width", "dpi", "addPhotoAuthorizationStatus",
  "photo_selected", "valid_photo_count", "invalid_photo_count", "case_id", "clone_id", "clone_count", "clone_left",
  "create_days", "task_id", "task_id_string", "task_status", "target_task_id", "more_similar", "category_id",
  "is_recover_from_cache", "succeed_number", "failed_number", "subscription_status", "subscription_status_updated",
  "params", "req_id", "run_env", "package_type", "idfa", "free_times_left", "from_model_id", "model_id",
  "model_id_list", "task_type", "person_count", "person_url", "free_trial_days", "free_trial_on_day_n",
  "target_clone_ids", "resolution_origin", "resolution_target", "resolution", "style_tag", "reason", "credits",
  "is_credit_updated", "media_type", "text_str", "text_num", "media_url", "media_src", "length_origin",
  "original_height", "original_width", "length_compressed", "video_duration", "video_url", "score", "is_saved",
  "platform", "distinct_id", "udid", "account_id", "account_platform", "unique_id", "is_login", "is_subscription_valid",
  "is_subscription_canceled", "is_subscription_expired", "is_credits_inside_buffer", "subscription_platform",
  "subscription_product_id", "subscription_product_price", "is_ever_subscribed", "language", "trace_id",
  "is_sys_night_mode", "is_app_night_mode", "random_id", "is_shoot_auth", "af_id", "model_count", "start_timestamp",
  "referrer_type", "referrer_trigger_tag", "is_watermarked", "height", "source_url", "target_url", "description",
  "option_name", "email", "is_external_start", "data_count", "is_kmp", "group_date", "delete_image_count",
  "parent_task_id_string", "trigger_type",
]

let tableSet: Set<String> = Set(
  "distinct_id  anonymous_id  time  track_id  version_code  flush_time  ngx_ip  recv_time  login_id  original_id  identities_json  lib_json  sa_is_first_day  lang  sa_utm_source  utm_campaign  region  device_id  server_tag  action  event_source  custom_test_id  platform  account_id  account_platform  unique_id  is_login  is_subscription_valid  is_subscription_canceled  is_subscription_expired  is_credits_inside_buffer  subscription_platform  subscription_product_id  subscription_product_price  credits  language  sa_os  trace_id  run_env  is_sys_night_mode  is_app_night_mode  duration  media_type  position_source  error  msg  referrer_type  resolution_origin  resolution_target  code  sa_url  task_status  index  trigger_tag  task_id_string  source_url  target_url  is_watermarked  style_id  model_id_list  gender  model_count  photo_count  photo_url  product_id  price  referrer_trigger_tag  transaction_id  task_type  width  height  reason  description  title  option_name  email  url  params  status  req_id  media_url  is_panel_expanded  is_kmp  dt  event  pay_channel  original_transaction_id  subscription_type  offer_type  subscription_status  total_amount  total_renew_count  auto_renew  continuous_count  peroid_continuous_count  start_time  end_time  purchase_type  origin_product_id  origin_price  af_id  campaign  media_source  notification_auth_status  ab_gorup  ratio  image_number  media_src  style_name  text_str  text_num  ab_group  random_id  original_height  original_width  file_format  group_date  succeed_number  failed_number  delete_image_count  data_count  udid  sa_app_id  sa_screen_width  sa_timezone_offset  sa_title  sa_track_signup_original_id  sa_url_path  sa_utm_campaign  sa_utm_content  sa_utm_medium  sa_utm_term  sa_wifi  sa_model  sa_network_type  sa_os_version  sa_province  sa_referrer  sa_referrer_host  sa_referrer_title  sa_resume_from_background  sa_screen_height  sa_screen_name  sa_idmap_reason  sa_ip  sa_is_login_id  sa_latest_utm_campaign  sa_latest_utm_content  sa_latest_utm_medium  sa_latest_utm_source  sa_latest_utm_term  sa_lib  sa_manufacturer  sa_bot_name  sa_brand  sa_browser  sa_browser_version  sa_carrier  sa_city  sa_country  sa_deeplink_url  sa_device_id  sa_event_duration  sa_app_name  sa_app_version  parent_task_id_string  trigger_type  success"
    .split(separator: "  ")
    .map { String($0) }
)

let missing = codeSet.subtracting(tableSet)
for item in missing {
  print(item)
}
