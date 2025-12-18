package com.mariosmant.webapp.musichub.catalog.service.service;

import java.util.List;
import java.util.Map;

public interface TrackSearchService {
    List<Map<String, Object>> search(String query) throws Exception;
}
