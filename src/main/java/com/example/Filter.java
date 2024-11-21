package com.example;

public class Filter {
	private int filterId;
	private String color;
	private String filterName;
	
	public Filter(int filterId, String color, String filterName) {
		this.setFilterId(filterId);
		this.setColor(color);
		this.setFilterName(filterName);
	}
	
	public Filter(String color, String filterName) {
		this.setColor(color);
		this.setFilterName(filterName);
	}

	public int getFilterId() {
		return filterId;
	}

	public void setFilterId(int filterId) {
		this.filterId = filterId;
	}

	public String getColor() {
		return color;
	}

	public void setColor(String color) {
		this.color = color;
	}

	public String getFilterName() {
		return filterName;
	}

	public void setFilterName(String filterName) {
		this.filterName = filterName;
	}
}