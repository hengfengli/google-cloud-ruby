# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: google/spanner/admin/database/v1/spanner_database_admin.proto

require 'google/protobuf'

require 'google/api/annotations_pb'
require 'google/api/client_pb'
require 'google/api/field_behavior_pb'
require 'google/api/resource_pb'
require 'google/iam/v1/iam_policy_pb'
require 'google/iam/v1/policy_pb'
require 'google/longrunning/operations_pb'
require 'google/protobuf/empty_pb'
require 'google/protobuf/timestamp_pb'
require 'google/spanner/admin/database/v1/backup_pb'
require 'google/spanner/admin/database/v1/common_pb'
Google::Protobuf::DescriptorPool.generated_pool.build do
  add_file("google/spanner/admin/database/v1/spanner_database_admin.proto", :syntax => :proto3) do
    add_message "google.spanner.admin.database.v1.RestoreInfo" do
      optional :source_type, :enum, 1, "google.spanner.admin.database.v1.RestoreSourceType"
      oneof :source_info do
        optional :backup_info, :message, 2, "google.spanner.admin.database.v1.BackupInfo"
      end
    end
    add_message "google.spanner.admin.database.v1.Database" do
      optional :name, :string, 1
      optional :state, :enum, 2, "google.spanner.admin.database.v1.Database.State"
      optional :create_time, :message, 3, "google.protobuf.Timestamp"
      optional :restore_info, :message, 4, "google.spanner.admin.database.v1.RestoreInfo"
      optional :encryption_config, :message, 5, "google.spanner.admin.database.v1.EncryptionConfig"
      optional :version_retention_period, :string, 6
      optional :earliest_version_time, :message, 7, "google.protobuf.Timestamp"
    end
    add_enum "google.spanner.admin.database.v1.Database.State" do
      value :STATE_UNSPECIFIED, 0
      value :CREATING, 1
      value :READY, 2
      value :READY_OPTIMIZING, 3
    end
    add_message "google.spanner.admin.database.v1.ListDatabasesRequest" do
      optional :parent, :string, 1
      optional :page_size, :int32, 3
      optional :page_token, :string, 4
    end
    add_message "google.spanner.admin.database.v1.ListDatabasesResponse" do
      repeated :databases, :message, 1, "google.spanner.admin.database.v1.Database"
      optional :next_page_token, :string, 2
    end
    add_message "google.spanner.admin.database.v1.CreateDatabaseRequest" do
      optional :parent, :string, 1
      optional :create_statement, :string, 2
      repeated :extra_statements, :string, 3
      optional :encryption_config, :message, 4, "google.spanner.admin.database.v1.EncryptionConfig"
    end
    add_message "google.spanner.admin.database.v1.CreateDatabaseMetadata" do
      optional :database, :string, 1
    end
    add_message "google.spanner.admin.database.v1.GetDatabaseRequest" do
      optional :name, :string, 1
    end
    add_message "google.spanner.admin.database.v1.UpdateDatabaseDdlRequest" do
      optional :database, :string, 1
      repeated :statements, :string, 2
      optional :operation_id, :string, 3
    end
    add_message "google.spanner.admin.database.v1.UpdateDatabaseDdlMetadata" do
      optional :database, :string, 1
      repeated :statements, :string, 2
      repeated :commit_timestamps, :message, 3, "google.protobuf.Timestamp"
    end
    add_message "google.spanner.admin.database.v1.DropDatabaseRequest" do
      optional :database, :string, 1
    end
    add_message "google.spanner.admin.database.v1.GetDatabaseDdlRequest" do
      optional :database, :string, 1
    end
    add_message "google.spanner.admin.database.v1.GetDatabaseDdlResponse" do
      repeated :statements, :string, 1
    end
    add_message "google.spanner.admin.database.v1.ListDatabaseOperationsRequest" do
      optional :parent, :string, 1
      optional :filter, :string, 2
      optional :page_size, :int32, 3
      optional :page_token, :string, 4
    end
    add_message "google.spanner.admin.database.v1.ListDatabaseOperationsResponse" do
      repeated :operations, :message, 1, "google.longrunning.Operation"
      optional :next_page_token, :string, 2
    end
    add_message "google.spanner.admin.database.v1.RestoreDatabaseRequest" do
      optional :parent, :string, 1
      optional :database_id, :string, 2
      oneof :source do
        optional :backup, :string, 3
      end
    end
    add_message "google.spanner.admin.database.v1.RestoreDatabaseMetadata" do
      optional :name, :string, 1
      optional :source_type, :enum, 2, "google.spanner.admin.database.v1.RestoreSourceType"
      optional :progress, :message, 4, "google.spanner.admin.database.v1.OperationProgress"
      optional :cancel_time, :message, 5, "google.protobuf.Timestamp"
      optional :optimize_database_operation_name, :string, 6
      oneof :source_info do
        optional :backup_info, :message, 3, "google.spanner.admin.database.v1.BackupInfo"
      end
    end
    add_message "google.spanner.admin.database.v1.OptimizeRestoredDatabaseMetadata" do
      optional :name, :string, 1
      optional :progress, :message, 2, "google.spanner.admin.database.v1.OperationProgress"
    end
    add_enum "google.spanner.admin.database.v1.RestoreSourceType" do
      value :TYPE_UNSPECIFIED, 0
      value :BACKUP, 1
    end
  end
end

module Google
  module Cloud
    module Spanner
      module Admin
        module Database
          module V1
            RestoreInfo = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("google.spanner.admin.database.v1.RestoreInfo").msgclass
            Database = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("google.spanner.admin.database.v1.Database").msgclass
            Database::State = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("google.spanner.admin.database.v1.Database.State").enummodule
            ListDatabasesRequest = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("google.spanner.admin.database.v1.ListDatabasesRequest").msgclass
            ListDatabasesResponse = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("google.spanner.admin.database.v1.ListDatabasesResponse").msgclass
            CreateDatabaseRequest = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("google.spanner.admin.database.v1.CreateDatabaseRequest").msgclass
            CreateDatabaseMetadata = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("google.spanner.admin.database.v1.CreateDatabaseMetadata").msgclass
            GetDatabaseRequest = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("google.spanner.admin.database.v1.GetDatabaseRequest").msgclass
            UpdateDatabaseDdlRequest = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("google.spanner.admin.database.v1.UpdateDatabaseDdlRequest").msgclass
            UpdateDatabaseDdlMetadata = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("google.spanner.admin.database.v1.UpdateDatabaseDdlMetadata").msgclass
            DropDatabaseRequest = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("google.spanner.admin.database.v1.DropDatabaseRequest").msgclass
            GetDatabaseDdlRequest = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("google.spanner.admin.database.v1.GetDatabaseDdlRequest").msgclass
            GetDatabaseDdlResponse = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("google.spanner.admin.database.v1.GetDatabaseDdlResponse").msgclass
            ListDatabaseOperationsRequest = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("google.spanner.admin.database.v1.ListDatabaseOperationsRequest").msgclass
            ListDatabaseOperationsResponse = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("google.spanner.admin.database.v1.ListDatabaseOperationsResponse").msgclass
            RestoreDatabaseRequest = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("google.spanner.admin.database.v1.RestoreDatabaseRequest").msgclass
            RestoreDatabaseMetadata = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("google.spanner.admin.database.v1.RestoreDatabaseMetadata").msgclass
            OptimizeRestoredDatabaseMetadata = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("google.spanner.admin.database.v1.OptimizeRestoredDatabaseMetadata").msgclass
            RestoreSourceType = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("google.spanner.admin.database.v1.RestoreSourceType").enummodule
          end
        end
      end
    end
  end
end
