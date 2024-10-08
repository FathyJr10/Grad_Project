import React, { useState } from "react";
import Topbar from "../Topbar/Topbar";
import Sidebar from "../Sidebar/Sidebar";
import "./CBCTest.css";
import axios from "axios";
import { useLocation, useParams } from "react-router-dom";
import { calculateAge } from "../configure";
import configure from "../configure";


const liverData = [
  { name: "ALT", unit: "U/L", range: "10 - 130" },
  { name: "AST", unit: "U/L", range: "10 - 34" },
  {
    name: "ALB",
    unit: "g/dL",
    range: "3.4 - 5.4",
  },
  {
    name: "DBIL",
    unit: "mg/dL",
    range: "0 - 0.3",
  },
  {
    name: "TBIL",
    unit: "mg/dL",
    range: "0.1 - 1.2",
  },
  { name: "ALP", unit: "U/L", range: "24 - 147" },
];
function LiverTest() {
  const { id } = useParams();
  const location = useLocation();
  const [formData, setFormData] = useState({
    patient_id: id,
    appointment_id: "14",
  });

  const handleSubmit = (event) => {
    event.preventDefault();
    axios
      .post(`${configure.backURL}liver/new`, formData)
      .then((response) => {
        console.log("Data posted:", response.data);
        if (response.status === 201) {
          // Navigate to another page
          window.location.href = `/allpatientspage/patientresultpage/${id}`;
        }
        // Do something with the response, e.g. show a success message
      })
      .catch((error) => {
        console.error("Error posting data:", error);
        // Handle the error, e.g. show an error message
      });
  };
  console.log(formData);

  const handleChange = (event) => {
    const fieldName = event.target.name.toLowerCase();
    setFormData({
      ...formData,
      [fieldName]: event.target.value,
    });
  };
  const handleInput = (event) => {
    const fieldName = event.target.name;
    setFormData({
      ...formData,
      [fieldName]: event.target.value,
    });
  };
  const age = calculateAge(location.state?.age);

  return (
    <div>
      <Topbar />
      <Sidebar />
      <div
        className="App container col-6"
        style={{ position: "relative", top: "50px", width: 1000 }}
      >
        <h3>Patient Demoghraphics</h3>
        <form onSubmit={handleSubmit} noValidate>
          <div className="row mb-3">
            <div className="col-md-4">
              <label htmlFor="firstName">Name</label>
              <p className="patientdata">{location.state?.name} </p>
            </div>
            <div className="col-md-4">
              <label htmlFor="lastName">Age</label>
              <p className="patientdata">{age} </p>
            </div>
            <div className="col md-4">
              <label htmlFor="email">Patient's ID</label>
              <p className="patientdata">{id}</p>
            </div>
          </div>
          <div>
            <div className="row mb-4">
              <div className="col-md-6">
                <label>Referring Doctor</label>
                <input
                  className="form-control"
                  type="text"
                  name="referring_doctor"
                  // value={formData.referring_doctor}
                  onChange={handleInput}
                  noValidate
                />
              </div>
            </div>
          </div>
          <h3 className="mb-4">Liver Function Test</h3>
          <div className="row mb-3">
            <h6 className="col md-3"> </h6>
            <h6 className="col md-3">Result</h6>
            <h6 className="col md-3">Unit</h6>
            <h6 className="col md-3">Ref.Range</h6>
          </div>
          {liverData.map((item) => (
            <div className="row mb-3" key={item.name.toLowerCase()}>
              <div className="col-md-3">
                <label>{item.name}</label>
              </div>
              <input
                className="form-control col md-3 boxentry"
                type="number"
                name={item.name.toLowerCase()}
                value={formData[item.name.toLowerCase()] || ""}
                onChange={handleChange}
              />
              <label className="col md-3">{item.unit}</label>
              <label className="col md-3">{item.range}</label>
            </div>
          ))}
          <div>
            <label for="comments">Comments</label>
            <textarea
              className="commentbtn"
              id="comments"
              name="comments"
              value={formData.comments || ""}
              onChange={handleChange}
              placeholder="Write Comments.."
            ></textarea>
          </div>
          <div className="mb-9">
            <button type="submit" className="submitform">
              Submit
            </button>
          </div>{" "}
        </form>
      </div>
    </div>
  );
}

export default LiverTest;
