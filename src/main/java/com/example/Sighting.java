package com.example;

import java.util.Date;

public class Sighting {
	// plant_id, user_id, location_id, 
	private int sightingId;
	private int plantId;
	private int userId;
	private int locationId;
	private String description;
	private double radius;
	private byte[] photo;
	private Date date;

	public Sighting() {
	}

	public Sighting(int sightingId, int plantId, int userId, int locationId, String description, double radius, Date date) {
		this.setSightingId(sightingId);
		this.setPlantId(plantId);
		this.setUserId(userId);
		this.setLocationId(locationId);
		this.setDescription(description);
		this.setRadius(radius);
		this.setDate(date);
	}

	public int getSightingId() {
		return sightingId;
	}

	public void setSightingId(int sightingId) {
		this.sightingId = sightingId;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public double getRadius() {
		return radius;
	}

	public void setRadius(double radius) {
		this.radius = radius;
	}

	public byte[] getPhoto() {
		return photo;
	}

	public void setPhoto(byte[] photo) {
		this.photo = photo;
	}

	public Date getDate() {
		return date;
	}

	public void setDate(Date date) {
		this.date = date;
	}

	public int getPlantId() {
		return plantId;
	}

	public void setPlantId(int plantId) {
		this.plantId = plantId;
	}

	public int getUserId() {
		return userId;
	}

	public void setUserId(int userId) {
		this.userId = userId;
	}

	public int getLocationId() {
		return locationId;
	}

	public void setLocationId(int locationId) {
		this.locationId = locationId;
	}
}
