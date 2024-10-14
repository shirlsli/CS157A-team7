public class Location {
    private int locationId;
    private double latitude;
    private double longitude;
    private String name;

    public Location(int locationId, double latitude, double longitude, String name) {
        this.locationId = locationId;
        this.latitude = latitude;
        this.longitude = longitude;
        this.name = name;
    }
    
    public int getLocationId() {
        return locationId;
    }

    public void setLocationId(int locationId) {
        this.locationId = locationId;
    }

    public double getLatitude() {
        return latitude;
    }

    public void setLatitude(double latitude) {
        this.latitude = latitude;
    }

    public double getLongitude() {
        return longitude;
    }

    public void setLongitude(double longitude) {
        this.longitude = longitude;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}
