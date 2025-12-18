package com.mariosmant.webapp.musichub.catalog.service.service;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import org.elasticsearch.client.RequestOptions;
import org.elasticsearch.client.core.SearchRequest;
import org.elasticsearch.client.core.SearchResponse;
import org.elasticsearch.client.RestHighLevelClient;
import org.elasticsearch.index.query.QueryBuilders;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

@Service
public class ElasticsearchTrackSearchService implements TrackSearchService {

    private final RestHighLevelClient client;

    @Value("${app.elasticsearch.index}")
    private String esIndex;

    public ElasticsearchTrackSearchService(RestHighLevelClient client) {
        this.client = client;
    }

    @Override
    public List<Map<String, Object>> search(String query) throws IOException {
        SearchRequest request = new SearchRequest(esIndex);
        request.source().query(QueryBuilders.multiMatchQuery(query, "title", "artist", "album")).size(25);
        SearchResponse response = client.search(request, RequestOptions.DEFAULT);

        List<Map<String, Object>> hits = new ArrayList<Map<String, Object>>();
        response.getHits().forEach(hit -> {
            hits.add(hit.getSourceAsMap());
        });
        return hits;
    }
}
