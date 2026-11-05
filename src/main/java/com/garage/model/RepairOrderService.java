package com.garage.model;

import java.math.BigDecimal;

public class RepairOrderService {
    private int id;
    private int orderId;
    private int serviceId;
    private String serviceName;
    private BigDecimal price;
    private String notes;

    public RepairOrderService() {
    }

    public RepairOrderService(int id, int orderId, int serviceId, String serviceName, BigDecimal price, String notes) {
        this.id = id;
        this.orderId = orderId;
        this.serviceId = serviceId;
        this.serviceName = serviceName;
        this.price = price;
        this.notes = notes;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public int getServiceId() {
        return serviceId;
    }

    public void setServiceId(int serviceId) {
        this.serviceId = serviceId;
    }

    public String getServiceName() {
        return serviceName;
    }

    public void setServiceName(String serviceName) {
        this.serviceName = serviceName;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public int getQuantity() {
        return 1;
    }

    public BigDecimal getSubtotal() {
        return price;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }
}

