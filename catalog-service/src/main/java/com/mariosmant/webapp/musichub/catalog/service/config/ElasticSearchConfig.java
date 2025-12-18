package com.mariosmant.webapp.musichub.catalog.service.config;

import org.apache.http.HttpHost;
import org.elasticsearch.client.RestClient;
import org.elasticsearch.client.RestHighLevelClient;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class ElasticsearchConfig {

    @Value("${app.elasticsearch.host}")
    private String esHost;

    @Bean
    public RestHighLevelClient elasticsearchClient() {
        RestClient restClient = RestClient.builder(HttpHost.create(esHost)).build();
        return new RestHighLevelClient(restClient);
    }
}
