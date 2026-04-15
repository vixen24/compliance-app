module System
  class Storage
    VOLUME_PATH = "/mnt/HC_Volume_105389341" # for mounted volume
    PG_DATA_PATH = "/var/lib/postgresql/16/main" # for same server pg
    PG_DATA_PATH = "/postgres/pgdata" # for development

    class << self
      def used_bytes
        ActiveRecord::Base.connection.select_value(
          "SELECT pg_database_size(current_database())"
        ).to_i
      end

      def total_bytes
        df_info[1].to_i
      end

      def available_bytes
        df_info[2].to_i
      end

      def percent_used
        return 0 if total_bytes.zero?
        ((total_bytes - available_bytes).to_f / total_bytes * 100).round(2)
      end

      private

      def df_info
        output = `df -B1 #{PG_DATA_PATH} 2>/dev/null`.lines.last
        output ? output.split : [ nil, 0, 0 ]
      end
    end
  end
end
