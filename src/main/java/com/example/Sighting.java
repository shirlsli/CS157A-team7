package com.example;

import java.util.Date;

public class Sighting {
    private int sightingId;
    private String description;
    private double radius;
    private byte[] photo;
    private Date date;

    public Sighting(int sightingId, String description, double radius, Date date) {
        this.setSightingId(sightingId);
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
}
