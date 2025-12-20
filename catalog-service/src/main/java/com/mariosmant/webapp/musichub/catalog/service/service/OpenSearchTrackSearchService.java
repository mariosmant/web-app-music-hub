package com.mariosmant.webapp.musichub.catalog.service.service;

import java.util.List;
import java.util.Map;
import java.util.Objects;

import org.opensearch.client.opensearch.OpenSearchClient;
import org.opensearch.client.opensearch.core.SearchRequest;
import org.opensearch.client.opensearch.core.SearchResponse;
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
                        .query(q -> q.multiMatch(mm -> mm
                                .query(query)
                                .fields("title", "artist", "album")
                        ))
                        .size(25)
                        .build();

        SearchResponse<Map> response = client.search(request, Map.class);

        return response.hits()
                .hits()
                .stream()
                .map(h -> (Map<String, Object>) h.source())
                .filter(Objects::nonNull)
                .toList();
    }
}
