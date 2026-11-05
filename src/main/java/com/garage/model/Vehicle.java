package com.garage.model;

import java.sql.Timestamp;

public class Vehicle {
    private int vehicleId;
    private String licensePlate;
    private int customerId;
    private String customerName;
    private String customerPhone;
    private String vehicleType; // 'Ã” tÃ´' hoáº·c 'Xe mÃ¡y'
    private String brand;
    private String model;
    private String color;
    private int manufactureYear;
    private Timestamp createdAt;

    public Vehicle() {
    }

    public Vehicle(int vehicleId, String licensePlate, int customerId, String vehicleType, String brand, String model, String color, int manufactureYear) {
        this.vehicleId = vehicleId;
        this.licensePlate = licensePlate;
        this.customerId = customerId;
        this.vehicleType = vehicleType;
        this.brand = brand;
        this.model = model;
        this.color = color;
        this.manufactureYear = manufactureYear;
    }

    public int getVehicleId() {
        return vehicleId;
    }

    public void setVehicleId(int vehicleId) {
        this.vehicleId = vehicleId;
    }

    public String getLicensePlate() {
        return licensePlate;
    }

    public void setLicensePlate(String licensePlate) {
        this.licensePlate = licensePlate;
    }

    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getCustomerPhone() {
        return customerPhone;
    }

    public void setCustomerPhone(String customerPhone) {
        this.customerPhone = customerPhone;
    }

    public String getVehicleType() {
        return vehicleType;
    }

    public void setVehicleType(String vehicleType) {
        this.vehicleType = vehicleType;
    }

    public String getBrand() {
        return brand;
    }

    public void setBrand(String brand) {
        this.brand = brand;
    }

    public String getModel() {
        return model;
    }

    public void setModel(String model) {
        this.model = model;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public int getManufactureYear() {
        return manufactureYear;
    }

    public void setManufactureYear(int manufactureYear) {
        this.manufactureYear = manufactureYear;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getDisplayName() {
        return licensePlate + " (" + brand + " " + model + ")";
    }
}

