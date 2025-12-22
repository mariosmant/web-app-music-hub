package com.mariosmant.webapp.musichub.connect.smt;

import java.util.Map;
import org.apache.kafka.common.config.ConfigDef;
import org.apache.kafka.connect.connector.ConnectRecord;
import org.apache.kafka.connect.header.Headers;
import org.apache.kafka.connect.transforms.Transformation;

public class AddPortHeader<R extends ConnectRecord<R>> implements Transformation<R> {

    public static final String PORT_CONFIG = "port";
    private String portValue;

    @Override
    public R apply(R record) {
        if (record == null) {
            return null;
        }

        Headers headers = record.headers();
        headers.addString("x-index-port", portValue);

        return record;
    }


    @Override
    public ConfigDef config() {
        ConfigDef def = new ConfigDef();
        def.define(
            PORT_CONFIG,
            ConfigDef.Type.STRING,
            "9200",
            ConfigDef.Importance.HIGH,
            "Port to annotate in header x-index-port."
        );
        return def;
    }

    @Override
    public void close() { }

    @Override
    public void configure(Map<String, ?> configs) {
        Object value = configs.get(PORT_CONFIG);
        if (value == null) {
            portValue = "9200";
        } else {
            portValue = value.toString();
        }
    }

    @Override
    public String toString() {
        return "AddPortHeader(port=" + portValue + ")";
    }
}
