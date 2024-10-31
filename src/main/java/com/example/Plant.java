package com.example;

public class Plant {
	private int plantId;
	private String name;
	private String scientificName;
	private String description;
	private boolean poisonous;
	private boolean invasive;
	private boolean endangered;
	
	public Plant(int plantId, String name, String scientificName, String description, boolean poisonous, boolean invasive, boolean endangered) {
		setPlantId(plantId);
		setName(name);
		setScientificName(scientificName);
		setDescription(description);
		setPoisonous(poisonous);
		setInvasive(invasive);
		setEndangered(endangered);
	}
	
	public int getPlantId() {
		return plantId;
	}
	public void setPlantId(int plantId) {
		this.plantId = plantId;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getScientificName() {
		return scientificName;
	}
	public void setScientificName(String scientificName) {
		this.scientificName = scientificName;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public boolean isPoisonous() {
		return poisonous;
	}
	public void setPoisonous(boolean poisonous) {
		this.poisonous = poisonous;
	}
	public boolean isInvasive() {
		return invasive;
	}
	public void setInvasive(boolean invasive) {
		this.invasive = invasive;
	}
	public boolean isEndangered() {
		return endangered;
	}
	public void setEndangered(boolean endangered) {
		this.endangered = endangered;
	}
	
	
}