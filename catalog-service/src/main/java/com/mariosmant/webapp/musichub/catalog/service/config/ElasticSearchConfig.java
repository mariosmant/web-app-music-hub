//package com.mariosmant.webapp.musichub.catalog.service.config;
//
//import org.apache.http.HttpHost;
//import co.elastic.clients.elasticsearch.ElasticsearchClient;
//import co.elastic.clients.json.jackson.JacksonJsonpMapper;
//import co.elastic.clients.transport.rest_client.RestClientTransport;
//import org.springframework.beans.factory.annotation.Value;
//import org.springframework.context.annotation.Bean;
//import org.springframework.context.annotation.Configuration;
//
//@Configuration
//public class ElasticSearchConfig {
//
//    @Value("${app.elasticsearch.host}")
//    private String esHost;
//
//
//
//
//    @Bean
//    public ElasticsearchClient elasticsearchClient() {
//        // RestClient lowLevelClient = RestClient.builder(
//        //         new HttpHost("localhost", 9200, "http")
//        // ).build();
//        RestClient lowLevelClient = RestClient.builder(HttpHost.create(esHost)).build();
//
//        RestClientTransport transport =
//                new RestClientTransport(lowLevelClient, new JacksonJsonpMapper());
//
//        return new ElasticsearchClient(transport);
//    }
//
//
//    // @Bean
//    // public RestHighLevelClient elasticsearchClient() {
//    //     RestClient restClient = RestClient.builder(HttpHost.create(esHost)).build();
//    //     return new RestHighLevelClient(restClient);
//    // }
//}
