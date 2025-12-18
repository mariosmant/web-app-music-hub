package com.mariosmant.webapp.musichub.catalog.service.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import org.opensearch.client.opensearch.OpenSearchClient;
import org.opensearch.client.opensearch.core.SearchRequest;
import org.opensearch.client.opensearch.core.SearchResponse;
import org.opensearch.client.opensearch.core.search.Hit;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

@Service
public class OpenSearchTrackSearchService implements TrackSearchService {

    private final OpenSearchClient client;

    @Value("${app.opensearch.index}")
    private String osIndex;

    public OpenSearchTrackSearchService(OpenSearchClient client) {
        this.client = client;
    }

    @Override
    public List<Map<String, Object>> search(String query) throws Exception {
        SearchRequest request =
            new SearchRequest.Builder()
                .index(osIndex)
                .query(q -> q.multiMatch(mm -> mm.query(query).fields("title,artist,album")))
                .size(25)
                .build();

        SearchResponse<Map<String, Object>> response = client.search(request, Map.class);
        List<Map<String, Object>> hits = new ArrayList<Map<String, Object>>();
        for (Hit<Map<String, Object>> h : response.hits().hits()) {
            Map<String, Object> source = h.source();
            if (source != null) {
                hits.add(source);
            }
        }
        return hits;
    }
}
