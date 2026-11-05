package com.garage.model;

import java.math.BigDecimal;

public class RepairOrderPart {
    private int id;
    private int orderId;
    private int partId;
    private String partCode;
    private String partName;
    private String unit;
    private int quantity;
    private BigDecimal unitPrice;
    private BigDecimal totalPrice;

    public RepairOrderPart() {
    }

    public RepairOrderPart(int id, int orderId, int partId, String partCode, String partName, String unit, int quantity, BigDecimal unitPrice, BigDecimal totalPrice) {
        this.id = id;
        this.orderId = orderId;
        this.partId = partId;
        this.partCode = partCode;
        this.partName = partName;
        this.unit = unit;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.totalPrice = totalPrice;
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

    public int getPartId() {
        return partId;
    }

    public void setPartId(int partId) {
        this.partId = partId;
    }

    public String getPartCode() {
        return partCode;
    }

    public void setPartCode(String partCode) {
        this.partCode = partCode;
    }

    public String getPartName() {
        return partName;
    }

    public void setPartName(String partName) {
        this.partName = partName;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public BigDecimal getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(BigDecimal unitPrice) {
        this.unitPrice = unitPrice;
    }

    public BigDecimal getPrice() {
        return unitPrice;
    }

    public BigDecimal getSubtotal() {
        return totalPrice;
    }

    public BigDecimal getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(BigDecimal totalPrice) {
        this.totalPrice = totalPrice;
    }
}

