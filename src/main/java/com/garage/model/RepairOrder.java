package com.garage.model;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class RepairOrder {
    private int orderId;
    private String orderCode;
    private int vehicleId;
    private String licensePlate;
    private String vehicleInfo;
    private int customerId;
    private String customerName;
    private String customerPhone;
    private Integer technicianId;
    private String technicianName;
    private Timestamp receiveDate;
    private Timestamp completedDate;
    private String problemDescription;
    private String diagnosisNotes;
    private String status; // PENDING, IN_PROGRESS, COMPLETED, PAID, CANCELLED
    private BigDecimal totalServiceCost;
    private BigDecimal totalPartCost;
    private BigDecimal totalAmount;

    private List<RepairOrderService> services = new ArrayList<>();
    private List<RepairOrderPart> parts = new ArrayList<>();

    public RepairOrder() {
        this.totalServiceCost = BigDecimal.ZERO;
        this.totalPartCost = BigDecimal.ZERO;
        this.totalAmount = BigDecimal.ZERO;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public String getOrderCode() {
        return orderCode;
    }

    public void setOrderCode(String orderCode) {
        this.orderCode = orderCode;
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

    public String getVehicleInfo() {
        return vehicleInfo;
    }

    public void setVehicleInfo(String vehicleInfo) {
        this.vehicleInfo = vehicleInfo;
    }

    // Alias for JSP
    public String getVehicleModel() {
        return vehicleInfo;
    }

    public String getVehicleBrand() {
        return "";
    }

    public String getCustomerAddress() {
        return "Tại xưởng";
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

    public Integer getTechnicianId() {
        return technicianId;
    }

    public void setTechnicianId(Integer technicianId) {
        this.technicianId = technicianId;
    }

    public String getTechnicianName() {
        return technicianName;
    }

    public void setTechnicianName(String technicianName) {
        this.technicianName = technicianName;
    }

    public Timestamp getReceiveDate() {
        return receiveDate;
    }

    public void setReceiveDate(Timestamp receiveDate) {
        this.receiveDate = receiveDate;
    }

    // Alias for JSP
    public Timestamp getCreatedAt() {
        return receiveDate;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.receiveDate = createdAt;
    }

    public Timestamp getCompletedDate() {
        return completedDate;
    }

    public void setCompletedDate(Timestamp completedDate) {
        this.completedDate = completedDate;
    }

    public String getProblemDescription() {
        return problemDescription;
    }

    public void setProblemDescription(String problemDescription) {
        this.problemDescription = problemDescription;
    }

    public String getDiagnosisNotes() {
        return diagnosisNotes;
    }

    public void setDiagnosisNotes(String diagnosisNotes) {
        this.diagnosisNotes = diagnosisNotes;
    }

    // Alias for JSP
    public String getDiagnosis() {
        return diagnosisNotes;
    }

    public void setDiagnosis(String diagnosis) {
        this.diagnosisNotes = diagnosis;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public BigDecimal getTotalServiceCost() {
        return totalServiceCost;
    }

    public BigDecimal getServiceAmount() {
        return totalServiceCost;
    }

    public void setTotalServiceCost(BigDecimal totalServiceCost) {
        this.totalServiceCost = totalServiceCost;
    }

    public BigDecimal getTotalPartCost() {
        return totalPartCost;
    }

    public BigDecimal getPartAmount() {
        return totalPartCost;
    }

    public void setTotalPartCost(BigDecimal totalPartCost) {
        this.totalPartCost = totalPartCost;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

    public List<RepairOrderService> getServices() {
        return services;
    }

    public void setServices(List<RepairOrderService> services) {
        this.services = services;
    }

    public List<RepairOrderPart> getParts() {
        return parts;
    }

    public void setParts(List<RepairOrderPart> parts) {
        this.parts = parts;
    }
}
