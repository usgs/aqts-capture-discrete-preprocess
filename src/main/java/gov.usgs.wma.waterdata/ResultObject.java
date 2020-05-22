package gov.usgs.wma.waterdata;

public class ResultObject {
	// lambda output - what will we be passing on to the transform step?

	// definitely the json_data_id
	private Long id;

	// maybe other stuff, not sure yet

	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
}
