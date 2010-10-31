NewRelic::Agent.manual_start(AppConfig.newrelic.deep_to_h.merge({:config=>Rails.configuration}))
