/*-
 * ---license-start
 * CAMARA Project
 * ---
 * Copyright (C) 2022 - 2023 Contributors | Deutsche Telekom AG to CAMARA a Series of LF Projects, LLC
 *
 * The contributor of this file confirms his sign-off for the
 * Developer Certificate of Origin
 *             (https://developercertificate.org).
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


import static com.github.tomakehurst.wiremock.client.WireMock.aResponse;
import static com.github.tomakehurst.wiremock.client.WireMock.configureFor;
import static com.github.tomakehurst.wiremock.client.WireMock.delete;
import static com.github.tomakehurst.wiremock.client.WireMock.post;
import static com.github.tomakehurst.wiremock.client.WireMock.stubFor;
import static com.github.tomakehurst.wiremock.client.WireMock.urlEqualTo;
import static com.github.tomakehurst.wiremock.client.WireMock.urlMatching;
import static org.junit.jupiter.api.Assertions.assertEquals;

import com.github.tomakehurst.wiremock.WireMockServer;
import com.jayway.jsonpath.JsonPath;
import io.cucumber.java.BeforeAll;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import io.restassured.RestAssured;
import io.restassured.specification.RequestSpecification;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.AfterAll;


@Slf4j
public class Steps {

  private final static String PATH = "/qod/v0/sessions";
  private static WireMockServer wireMockServer;
  private io.restassured.response.Response response;
  private RequestSpecification request;

  @BeforeAll
  public static void setUp() {
    wireMockServer = new WireMockServer(AppConfig.SCEF_PORT);
    wireMockServer.start();
  }

  @Given("Use the QoD MOCK URL")
  public void useTheQoDMOCKURL() {
    RestAssured.reset();
    RestAssured.baseURI = AppConfig.BASE_URL;
    request = RestAssured.given();
    log.info("Setting up!");
    configureFor("localhost", AppConfig.SCEF_PORT);
    RestAssured.port = AppConfig.SCEF_PORT;
    stubFor(post(urlEqualTo(AppConfig.SCEF_PATH + "/subscriptions"))
        .willReturn(aResponse()
            .withStatus(201)
            .withHeader("Content-Type", "application/json")
            //QoD Session API needs only subscription-id from response and hence only self is considered
            .withBody("{\"self\": \"https://foo.com/subscriptions/123\"}")
        )
    );
    log.info("MockServer Started");
    stubFor(delete(urlMatching(AppConfig.SCEF_PATH + "/subscriptions/123")).willReturn(
        aResponse().withStatus(204)));
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

  @When("Delete existing QoD session")
  public void deleteexistingQoDSession() {
    String sessionId = JsonPath.read(response.asString(), "id");
    log.info(sessionId);
    String path = PATH + "/" + sessionId;
    response = request.delete(path);
  }

  @When("Delete Invalid QoD session")
  public void deleteInvalidSession() {
    String path = PATH + "/" + AppConfig.SESSION_ID;
    response = request.delete(path);
  }

  @Then("Response code is {int}")
  public void checkResponse(int iResponse) {
    assertEquals(iResponse, response.getStatusCode());
  }

  @AfterAll
  public static void afterAll() {
    System.out.println("Running: tearDown");
    wireMockServer.stop();
  }


  @When("Create a new QoD session with all parameters")
  public void createANewQoDSessionWithAllParameters() {
    postRequestByResource(AppConfig.JSON_STRING_ALL);
  }

  @When("Get QoD session")
  public void getSession() {
    String sessionId = JsonPath.read(response.asString(), "id");
    String path = PATH + "/" + sessionId;
    response = request.get(path);
    log.info("Response HTTP Status code: " + response.getStatusCode());
  }

  @Given("Use the QoD MOCK URL with invalid scenario")
  public void useTheQoDMOCKURLWithInvalidScenario() {
    RestAssured.reset();
    RestAssured.baseURI = AppConfig.BASE_URL;
    request = RestAssured.given();
    log.info("Setting up!");
    configureFor("localhost", AppConfig.SCEF_PORT);
    RestAssured.port = AppConfig.SCEF_PORT;
    stubFor(post(urlEqualTo(AppConfig.SCEF_PATH + "/subscriptions"))
        .willReturn(aResponse()
            .withStatus(500)
            .withHeader("Content-Type", "application/json")
            .withBody("{\"self\": \"https://foo.com/subscriptions/\"}")
        )
    );
  }

  @When("Create a new QoD session with parameters")
  public void createANewQoDSessionWithParameters() {

    postRequestByResource(AppConfig.JSON_STRING_MANDATORY_FAIL);
  }

  @When("Create a new QoD session along with all parameters")
  public void createANewQoDSessionAlongWithAllParameters() {
    postRequestByResource(AppConfig.JSON_STRING_ALL_PARAMS);
  }
}
