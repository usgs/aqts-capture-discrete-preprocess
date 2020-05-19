package gov.usgs.wma.waterdata;

public class TimeSeries {
    private String jsonDataId;
    private String dataType;
    public String getUniqueId() {
        return jsonDataId;
    }
    public void setJsonDataId(int jsonDataId) {
        this.jsonDataId = jsonDataId;
    }
    public String getDataType() {
        return dataType;
    }
    public void setDataType(String dataType) {
        this.dataType = dataType;
    }
}