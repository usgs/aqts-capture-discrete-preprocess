package gov.usgs.wma.waterdata;

import java.util.function.Function;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

@Component
public class ProcessFieldVisit implements Function<RequestObject, ResultObject> {
	private static final Logger LOG = LoggerFactory.getLogger(ProcessFieldVisit.class);

	private FieldVisitDao fieldVisitDao;

	@Autowired
	public ProcessFieldVisit(FieldVisitDao fieldVisitDao) {
		this.fieldVisitDao = fieldVisitDao;
	}

	@Override
	@Transactional
	public ResultObject apply(RequestObject request) {
		return processRequest(request);
	}

	@Transactional
	protected ResultObject processRequest(RequestObject request) {
		Long jsonDataId = request.getId();
		LOG.debug("json_data_id: {}", jsonDataId);
		ResultObject result = new ResultObject();

		// logic to insert the relevant field visit header and readings information
		// from the json_data table and into the field_visit_header_info and field_visit_readings tables
		// We'll use the FieldVisitDao to interact with the database

		// the updates will return a number of rows updated - maybe we'll want to return these for
		// informational purposes on the result object

		fieldVisitDao.doHeaderInfo(jsonDataId);
		fieldVisitDao.doReadings(jsonDataId);

		result.setId(jsonDataId);

		return result;
	}
}
