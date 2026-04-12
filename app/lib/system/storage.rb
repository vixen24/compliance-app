module System
  class Storage
    class << self
      def used_bytes
        ActiveRecord::Base.connection.select_value(
          "SELECT pg_database_size(current_database())"
        ).to_i
      end

      def total_bytes
        disk_info[1].to_i
      end

      def storage_partition
        disk_info[0].to_i
      end

      def percent_used
        return 0 if total_bytes.zero?
        (used_bytes.to_f / total_bytes * 100).round(2)
      end

      private

      def postgres_data_directory
        ActiveRecord::Base.connection.select_value(
          "SHOW data_directory"
        )
      end

      def disk_info
        dir = Shellwords.escape(postgres_data_directory)
        `df -B1 #{dir}`.lines.last.split
      end
    end
  end
end
