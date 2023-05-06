package com.wecare.backend2.Diagnosis;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.wecare.backend2.Doctor.Doctor;
import com.wecare.backend2.Patient.Patient;
import jakarta.persistence.*;

@Entity
public class Diagnosis {

    @Id
    @GeneratedValue
    private int diagnosisId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JsonIgnore
    private Patient patient;

    @ManyToOne(fetch = FetchType.LAZY)
    @JsonIgnore
    private Doctor doctor;

    private String bodyPartExamined;

    private String Medications;

    private String Report;

    public String getBodyPartExamined() {
        return bodyPartExamined;
    }

    public void setBodyPartExamined(String bodyPartExamined) {
        this.bodyPartExamined = bodyPartExamined;
    }

    public String getMedications() {
        return Medications;
    }

    public void setMedications(String medications) {
        Medications = medications;
    }

    public String getReport() {
        return Report;
    }

    public void setReport(String report) {
        Report = report;
    }

    public Diagnosis(int diagnosisId, Patient patient, Doctor doctor) {
        this.diagnosisId = diagnosisId;
        this.patient = patient;
        this.doctor = doctor;
    }

    public Diagnosis() {
    }

    public int getDiagnosisId() {
        return diagnosisId;
    }

    public Patient getPatient() {
        return patient;
    }

    public void setPatient(Patient patient) {
        this.patient = patient;
    }

    public Doctor getDoctor() {
        return doctor;
    }

    public void setDoctor(Doctor doctor) {
        this.doctor = doctor;
    }
}
