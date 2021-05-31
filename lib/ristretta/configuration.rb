module Ristretta
  class Configuration
    attr_accessor :redis_client, 
                  :namespace,
                  :subject_id_method,
                  :version

    def initialize
      @version = "1"
      @namespace = "ristretta"
      @subject_id_method = :id
    end

    def client
      @client ||= redis_client
    end
  end
end