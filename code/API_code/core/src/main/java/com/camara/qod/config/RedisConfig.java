/*-
 * ---license-start
 * CAMARA Project
 * ---
 * Copyright (C) 2022 Contributors | Deutsche Telekom AG to CAMARA a Series of LF Projects, LLC
 * The contributor of this file confirms his sign-off for the
 * Developer Certificate of Origin (http://developercertificate.org).
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

package com.camara.qod.config;

import static org.springframework.data.redis.core.RedisKeyValueAdapter.EnableKeyspaceEvents.ON_STARTUP;

import lombok.Getter;
import net.javacrumbs.shedlock.core.LockProvider;
import net.javacrumbs.shedlock.provider.redis.spring.RedisLockProvider;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.redis.connection.RedisStandaloneConfiguration;
import org.springframework.data.redis.connection.lettuce.LettuceConnectionFactory;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.repository.configuration.EnableRedisRepositories;

/**
 * This class contains specific configurations for the Redis database.
 */
@Configuration
@Getter
@EnableRedisRepositories(enableKeyspaceEvents = ON_STARTUP)
public class RedisConfig {
  @Value("${spring.redis.port}")
  private int redisPort;

  @Value("${spring.redis.host}")
  private String redisHost;

  private final String qosSessionExpirationListName = "QoSSessionExpirationList";

  /**
   * Creates a redis connection instance with Lettuce connector.
   *
   * @return LettuceConnection instance
   */
  @Bean
  LettuceConnectionFactory redisConnectionFactory() {
    RedisStandaloneConfiguration redisConfig =
        new RedisStandaloneConfiguration(redisHost, redisPort);
    return new LettuceConnectionFactory(redisConfig);
  }

  /**
   * Creates a RedisTemplate for access to Redis data.
   *
   * @return RedisTemplate instance
   */
  @Bean
  public RedisTemplate<?, ?> redisTemplate() {
    RedisTemplate<?, ?> template = new RedisTemplate<>();
    template.setConnectionFactory(redisConnectionFactory());
    return template;
  }

  /**
   * Create a RedisLockProvider instance for the use of Shedlock with redis.
   *
   * @return RedisLockProvider instance
   */
  @Bean
  public LockProvider lockProvider() {
    return new RedisLockProvider(redisConnectionFactory());
  }
}
