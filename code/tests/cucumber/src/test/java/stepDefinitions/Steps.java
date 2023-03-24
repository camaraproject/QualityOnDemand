/*-
 * ---license-start
 * CAMARA Project
 * ---
 * Copyright (C) 2022 Contributors | Deutsche Telekom AG to
 * 						CAMARA a Series of LF
 * 						Projects, LLC
 * The contributor of this
 * 						file confirms his sign-off for
 * 						the
 * Developer
 * 						Certificate of
 * 						Origin (http://developercertificate.org).
 * ---
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ---license-end
 */

package stepDefinitions;

import static org.junit.jupiter.api.Assertions.assertEquals;

import com.jayway.jsonpath.JsonPath;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import io.restassured.RestAssured;
import io.restassured.specification.RequestSpecification;
import lombok.extern.slf4j.Slf4j;


@Slf4j
public class Steps {

  private io.restassured.response.Response response;
  private de.telekom.gac_client.mg_manager.cmd.allocation.Response allocationResponse;
  private RequestSpecification request;
  private final static String PATH = "/qod/v0/sessions";


  @Given("Use the BaseURL")
  public void init() {
    RestAssured.reset();
    RestAssured.baseURI = AppConfig.BASE_URL;
    request = RestAssured.given();
  }

  public void postRequestByResource(String requestBody) {
    request.header("Content-Type", "application/json");
    log.info(requestBody);
    response = request.body(requestBody).post(PATH);
    log.info("Response HTTP Status code: " + response.getStatusCode());
    log.info("Response Body: " + response.getBody().asString());
  }

  @When("Create a new QoD session with mandatory parameters")
  public void createSession() {
    postRequestByResource(AppConfig.JSON_STRING_MANDATORY);
  }

  @When("Get QoD session")
  public void getSession() {
    String sessionId = JsonPath.read(response.asString(), "id");
    String path = PATH + "/" + sessionId;
    response = request.get(path);
    log.info("Response HTTP Status code: " + response.getStatusCode());
  }

  @When("Delete QoD session")
  public void deleteSession() {
    String sessionId = JsonPath.read(response.asString(), "id");
    String path = PATH + "/" + sessionId;
    response = request.delete(path);
  }

  @Then("Response code is {int}")
  public void checkResponse(int iResponse) {
    assertEquals(iResponse, response.getStatusCode());
  }

  @When("Create a new QoD session with all parameters")
  public void createANewQoDSessionWithAllParameters() {
    postRequestByResource(AppConfig.JSON_STRING_ALL);
  }


  @When("Create a new QoD session with missing double quote in json payload")
  public void createANewQoDSessionWithMissingDoubleQuoteInJsonPayload() {
    postRequestByResource(AppConfig.JSON_STRING_MISSING_DOUBLE_QUOTE);
  }

  @When("Create a new QoD session with missing bracket in json payload")
  public void createANewQoDSessionWithMissingBracketInJsonPayload() {
    postRequestByResource(AppConfig.JSON_STRING_MISSING_BRACKET);
  }

  @When("Create a new QoD session with incorrect msisdn in json payload")
  public void createANewQoDSessionWithIncorrectMsisdnInJsonPayload() {
    postRequestByResource(AppConfig.JSON_STRING_INCORRECT_MSISDN);
  }

  @When("Create a new QoD session with incorrect ipaddress in json payload")
  public void createANewQoDSessionWithIncorrectIpaddressInJsonPayload() {
    postRequestByResource(AppConfig.JSON_STRING_INCORRECT_IP);
  }

  @When("Create a new QoD session with missing {string} in json payload")
  public void createANewQoDSessionWithMissingInJsonPayload(String arg0) {
    postRequestByResource(AppConfig.JSON_STRING_MISSING_QOS);
  }

  @When("Create a new QoD session for an unknown or expired session id")
  public void createANewQoDSessionForAnUnknownOrExpiredSessionId() {
    String path = PATH + "/" + AppConfig.INVALID_SESSION_ID;
    response = request.get(path);
    log.info("Response HTTP Status code: " + response.getStatusCode());
  }

  @Then("Response in message is QoD session not found")
  public void responseInMessageIsQoDSessionNotFound() {
    String message = JsonPath.read(response.asString(), "message");
    log.info("Response message: " + message);
    assertEquals("Session Id does not exist", message);
  }


  

}
