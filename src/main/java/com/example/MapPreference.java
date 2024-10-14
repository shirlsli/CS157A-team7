package com.example;

public class MapPreference {
	private int preferenceId;
	private int userId;
	private int filterId;
	private int locationId;
	private int zoom;
	
	public MapPreference(int preferenceId, int userId, int filterId, int locationId, int zoom) {
		this.setPreferenceId(preferenceId);
		this.setUserId(userId);
		this.setFilterId(filterId);
		this.setLocationId(locationId);
		this.setZoom(zoom);
	}

	public int getPreferenceId() {
		return preferenceId;
	}

	public void setPreferenceId(int preferenceId) {
		this.preferenceId = preferenceId;
	}

	public int getUserId() {
		return userId;
	}

	public void setUserId(int userId) {
		this.userId = userId;
	}

	public int getFilterId() {
		return filterId;
	}

	public void setFilterId(int filterId) {
		this.filterId = filterId;
	}

	public int getLocationId() {
		return locationId;
	}

	public void setLocationId(int locationId) {
		this.locationId = locationId;
	}

	public int getZoom() {
		return zoom;
	}

	public void setZoom(int zoom) {
		this.zoom = zoom;
	}
}