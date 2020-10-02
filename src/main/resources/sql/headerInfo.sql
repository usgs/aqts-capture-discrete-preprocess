insert into field_visit_header_info (json_data_id,
                                     field_visit_identifier,
                                     location_identifier,
                                     start_time,
                                     end_time,
                                     party,
                                     remarks,
                                     weather,
                                     is_valid,
                                     completed_work,
                                     last_modified,
                                     partition_number)
select
  a.json_data_id,
  jsonb_extract_path_text(a.field_visit_data, 'Identifier') field_visit_identifier,
  jsonb_extract_path_text(a.field_visit_data, 'LocationIdentifier') location_identifier,
  adjust_timestamp(jsonb_extract_path_text(a.field_visit_data, 'StartTime')) start_time,
  adjust_timestamp(jsonb_extract_path_text(a.field_visit_data, 'EndTime')) end_time,
  jsonb_extract_path_text(a.field_visit_data, 'Party') party,
  jsonb_extract_path_text(a.field_visit_data, 'Remarks') remarks,
  jsonb_extract_path_text(a.field_visit_data, 'Weather') weather,
  jsonb_extract_path_text(a.field_visit_data, 'IsValid') is_valid,
  jsonb_extract_path(a.field_visit_data, 'CompletedWork') completed_work,
  adjust_timestamp(jsonb_extract_path_text(a.field_visit_data, 'LastModified')) last_modified,
  a.partition_number
from (
       select
         jd.json_data_id,
         jsonb_array_elements(jsonb_extract_path(jsonb_extract_path(jd.json_content, 'FieldVisitDataResponse'), 'FieldVisitData')) as field_visit_data,
         jd.partition_number
       from json_data jd
       where json_data_id = ?
       and partition_number = ?
       ) a
