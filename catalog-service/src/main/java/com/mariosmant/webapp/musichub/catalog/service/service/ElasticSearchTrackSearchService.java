package com.mariosmant.webapp.musichub.catalog.service.service;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import co.elastic.clients.elasticsearch.ElasticsearchClient;
import co.elastic.clients.elasticsearch.core.SearchResponse;


import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

@Service
public class ElasticSearchTrackSearchService implements TrackSearchService {

    private final ElasticsearchClient client;

    @Value("${app.elasticsearch.index}")
    private String esIndex;

    public ElasticSearchTrackSearchService(ElasticsearchClient client) {
        this.client = client;
    }

    @Override
    public List<Map<String, Object>> search(String query) throws IOException {

        SearchResponse<Map> response = client.search(s -> s
                        .index(esIndex)
                        .query(q -> q
                                .multiMatch(mm -> mm
                                        .query(query)
                                        .fields("title", "artist", "album")
                                )
                        )
                        .size(25),
                Map.class
        );


        List<Map<String, Object>> hits = new ArrayList<>();

        response.hits().hits().forEach(h -> {
            Map<String, Object> source = (Map<String, Object>) h.source();
            if (source != null) {
                hits.add(source);
            }
        });

        return hits;
    }
}
