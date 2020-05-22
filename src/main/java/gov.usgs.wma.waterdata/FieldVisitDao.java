package gov.usgs.wma.waterdata;

import java.io.IOException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.FileCopyUtils;

@Component
public class FieldVisitDao {
	private static final Logger LOG = LoggerFactory.getLogger(FieldVisitDao.class);

	@Autowired
	protected JdbcTemplate jdbcTemplate;

	@Value("classpath:sql/headerInfo.sql")
	private Resource headerInfo;

	@Value("classpath:sql/readings.sql")
	private Resource readings;

	@Transactional
	public void doHeaderInfo(Long jsonDataId) {
		doUpdate(jsonDataId, headerInfo);
	}

	@Transactional
	public void doReadings(Long jsonDataId) {
		doUpdate(jsonDataId, readings);
	}

	@Transactional
	protected void doUpdate(Long jsonDataId, Resource resource) {
		jdbcTemplate.update(getSql(resource), jsonDataId);
	}

	protected String getSql(Resource resource) {
		String sql = null;
		try {
			sql = new String(FileCopyUtils.copyToByteArray(resource.getInputStream()));
		} catch (IOException e) {
			LOG.error("Unable to get SQL statement", e);
			throw new RuntimeException(e);
		}
		return sql;
	}
}
