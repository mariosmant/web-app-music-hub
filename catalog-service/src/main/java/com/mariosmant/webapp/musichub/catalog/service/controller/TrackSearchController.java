package com.mariosmant.webapp.musichub.catalog.service.controller;

import java.util.List;
import java.util.Map;
import com.mariosmant.webapp.musichub.catalog.service.service.ElasticsearchTrackSearchService;
import com.mariosmant.webapp.musichub.catalog.service.service.OpenSearchTrackSearchService;
import io.github.resilience4j.circuitbreaker.annotation.CircuitBreaker;
import io.github.resilience4j.retry.annotation.Retry;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/search")
public class TrackSearchController {

    private final ElasticsearchTrackSearchService esService;
    private final OpenSearchTrackSearchService osService;

    public TrackSearchController(ElasticsearchTrackSearchService esService,
                                 OpenSearchTrackSearchService osService) {
        this.esService = esService;
        this.osService = osService;
    }

    @GetMapping("/es")
    @CircuitBreaker(name = "esBreaker")
    @Retry(name = "esRetry")
    public ResponseEntity<List<Map<String, Object>>> searchEs(@RequestParam("q") String query) throws Exception {
        List<Map<String, Object>> hits = esService.search(query);
        return ResponseEntity.ok(hits);
    }

    @GetMapping("/opensearch")
    @CircuitBreaker(name = "osBreaker")
    @Retry(name = "osRetry")
    public ResponseEntity<List<Map<String, Object>>> searchOpenSearch(@RequestParam("q") String query) throws Exception {
        List<Map<String, Object>> hits = osService.search(query);
        return ResponseEntity.ok(hits);
    }
}
