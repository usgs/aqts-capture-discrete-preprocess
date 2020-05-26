insert into field_visit_readings (
  json_data_id,
	parameter,
	monitoring_method,
	field_visit_value,
	unit,
	uncertainty,
    reading_type,
	manufacturer,
	model,
	serial_number,
	field_visit_time,
	field_visit_comments,
	publish,
	is_valid,
	reference_point_unique_id,
	use_location_datum_as_reference,
	reading_qualifier,
	reading_qualifiers,
	ground_water_measurement
)
select
  b.json_data_id,
  jsonb_extract_path_text(b.reading, 'Parameter') parameter,
  jsonb_extract_path_text(b.reading, 'MonitoringMethod') monitoring_method,
  jsonb_extract_path(b.reading, 'Value') field_visit_value,
  jsonb_extract_path_text(b.reading, 'Unit') unit,
  jsonb_extract_path(b.reading, 'Uncertainty') uncertainty,
  jsonb_extract_path_text(b.reading, 'ReadingType') reading_type,
  jsonb_extract_path_text(b.reading, 'Manufacturer') manufacturer,
  jsonb_extract_path_text(b.reading, 'Model') model,
  jsonb_extract_path_text(b.reading, 'SerialNumber') serial_number,
  adjust_timestamp(jsonb_extract_path_text(b.reading, 'Time')) field_visit_time,
  jsonb_extract_path_text(b.reading, 'Comments') field_visit_comments,
  jsonb_extract_path_text(b.reading, 'Publish') publish,
  jsonb_extract_path_text(b.reading, 'IsValid') is_valid,
  jsonb_extract_path_text(b.reading, 'ReferencePointUniqueId') reference_point_unique_id,
  jsonb_extract_path_text(b.reading, 'UseLocationDatumAsReference') use_location_datum_as_reference,
  jsonb_extract_path(b.reading, 'ReadingQualifier') reading_qualifier,
  jsonb_extract_path(b.reading, 'ReadingQualifiers') reading_qualifiers,
  jsonb_extract_path(b.reading, 'GroundWaterMeasurement') ground_water_measurement
from (
  select
    a.json_data_id,
    jsonb_array_elements(jsonb_extract_path(a.inspection_activity, 'Readings')) reading
    from (
      select
        jd.json_data_id,
        jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(jd.json_content, 'FieldVisitData')), 'InspectionActivity') as inspection_activity
        from
          json_data jd
        where json_data_id = ?
    ) a
) b;