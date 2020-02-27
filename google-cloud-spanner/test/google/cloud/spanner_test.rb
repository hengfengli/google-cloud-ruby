# Copyright 2016 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require "helper"

describe Google::Cloud do
  describe "#spanner" do
    it "calls out to Google::Cloud.spanner" do
      gcloud = Google::Cloud.new
      stubbed_spanner = ->(project, keyfile, scope: nil, timeout: nil, host: nil, client_config: nil, lib_name: nil, lib_version: nil) {
        project.must_be :nil?
        keyfile.must_be :nil?
        scope.must_be :nil?
        timeout.must_be :nil?
        host.must_be :nil?
        client_config.must_be :nil?
        lib_name.must_be :nil?
        lib_version.must_be :nil?
        "spanner-project-object-empty"
      }
      Google::Cloud.stub :spanner, stubbed_spanner do
        project = gcloud.spanner
        project.must_equal "spanner-project-object-empty"
      end
    end

    it "passes project and keyfile to Google::Cloud.spanner" do
      gcloud = Google::Cloud.new "project-id", "keyfile-path"
      stubbed_spanner = ->(project, keyfile, scope: nil, timeout: nil, host: nil, client_config: nil, lib_name: nil, lib_version: nil) {
        project.must_equal "project-id"
        keyfile.must_equal "keyfile-path"
        scope.must_be :nil?
        timeout.must_be :nil?
        host.must_be :nil?
        client_config.must_be :nil?
        lib_name.must_be :nil?
        lib_version.must_be :nil?
        "spanner-project-object"
      }
      Google::Cloud.stub :spanner, stubbed_spanner do
        project = gcloud.spanner
        project.must_equal "spanner-project-object"
      end
    end

    it "passes project and keyfile and options to Google::Cloud.spanner" do
      gcloud = Google::Cloud.new "project-id", "keyfile-path"
      stubbed_spanner = ->(project, keyfile, scope: nil, timeout: nil, host: nil, client_config: nil, lib_name: nil, lib_version: nil) {
        project.must_equal "project-id"
        keyfile.must_equal "keyfile-path"
        scope.must_equal "http://example.com/scope"
        timeout.must_equal 60
        host.must_be :nil?
        client_config.must_equal({ "gax" => "options" })
        lib_name.must_be :nil?
        lib_version.must_be :nil?
        "spanner-project-object-scoped"
      }
      Google::Cloud.stub :spanner, stubbed_spanner do
        project = gcloud.spanner scope: "http://example.com/scope", timeout: 60, client_config: { "gax" => "options" }
        project.must_equal "spanner-project-object-scoped"
      end
    end

    it "passes lib name and version to Google::Cloud.spanner" do
      gcloud = Google::Cloud.new
      stubbed_spanner = ->(project, keyfile, scope: nil, timeout: nil, host: nil, client_config: nil, lib_name: nil, lib_version: nil) {
        project.must_be :nil?
        keyfile.must_be :nil?
        scope.must_be :nil?
        timeout.must_be :nil?
        host.must_be :nil?
        client_config.must_be :nil?
        lib_name.must_equal "spanner-ruby"
        lib_version.must_equal "1.0.0"
        "spanner-project-object-with-lib-version-name"
      }
      Google::Cloud.stub :spanner, stubbed_spanner do
        project = gcloud.spanner lib_name: "spanner-ruby", lib_version: "1.0.0"
        project.must_equal "spanner-project-object-with-lib-version-name"
      end
    end
  end

  describe ".spanner" do
    let(:default_credentials) do
      creds = OpenStruct.new empty: true
      def creds.is_a? target
        target == Google::Auth::Credentials
      end
      creds
    end
    let(:found_credentials) { "{}" }

    it "gets defaults for project_id and keyfile" do
      # Clear all environment variables
      ENV.stub :[], nil do
        # Get project_id from Google Compute Engine
        Google::Cloud.stub :env, OpenStruct.new(project_id: "project-id") do
          Google::Cloud::Spanner::Credentials.stub :default, default_credentials do
            spanner = Google::Cloud.spanner
            spanner.must_be_kind_of Google::Cloud::Spanner::Project
            spanner.project.must_equal "project-id"
            spanner.service.credentials.must_equal default_credentials
          end
        end
      end
    end

    it "uses provided project_id and keyfile" do
      stubbed_credentials = ->(keyfile, scope: nil) {
        keyfile.must_equal "path/to/keyfile.json"
        scope.must_be :nil?
        "spanner-credentials"
      }
      stubbed_service = ->(project, credentials, timeout: nil, host: nil, client_config: nil, **keyword_args) {

        project.must_equal "project-id"
        credentials.must_equal "spanner-credentials"
        timeout.must_be :nil?
        host.must_be :nil?
        client_config.must_be :nil?
        keyword_args.key?(:lib_name).must_equal true
        keyword_args.key?(:lib_version).must_equal true
        keyword_args[:lib_name].must_be :nil?
        keyword_args[:lib_version].must_be :nil?
        OpenStruct.new project: project
      }

      # Clear all environment variables
      ENV.stub :[], nil do
        File.stub :file?, true, ["path/to/keyfile.json"] do
          File.stub :read, found_credentials, ["path/to/keyfile.json"] do
            Google::Cloud::Spanner::Credentials.stub :new, stubbed_credentials do
              Google::Cloud::Spanner::Service.stub :new, stubbed_service do
                spanner = Google::Cloud.spanner "project-id", "path/to/keyfile.json"
                spanner.must_be_kind_of Google::Cloud::Spanner::Project
                spanner.project.must_equal "project-id"
                spanner.service.must_be_kind_of OpenStruct
              end
            end
          end
        end
      end
    end
  end

  describe "Spanner.new" do
    let(:default_credentials) do
      creds = OpenStruct.new empty: true
      def creds.is_a? target
        target == Google::Auth::Credentials
      end
      creds
    end
    let(:found_credentials) { "{}" }

    it "gets defaults for project_id, keyfile, lib_name and lib_version" do
      # Clear all environment variables
      ENV.stub :[], nil do
        # Get project_id from Google Compute Engine
        Google::Cloud.stub :env, OpenStruct.new(project_id: "project-id") do
          Google::Cloud::Spanner::Credentials.stub :default, default_credentials do
            spanner = Google::Cloud::Spanner.new
            spanner.must_be_kind_of Google::Cloud::Spanner::Project
            spanner.project.must_equal "project-id"
            spanner.service.credentials.must_equal default_credentials
            spanner.service.lib_name.must_be :nil?
            spanner.service.lib_version.must_be :nil?
            spanner.service.send(:lib_name_with_prefix).must_equal "gccl"
          end
        end
      end
    end

    it "uses provided project_id and credentials" do
      stubbed_credentials = ->(keyfile, scope: nil) {
        keyfile.must_equal "path/to/keyfile.json"
        scope.must_be :nil?
        "spanner-credentials"
      }
      stubbed_service = ->(project, credentials, timeout: nil, host: nil, client_config: nil, **keyword_args) {
        project.must_equal "project-id"
        credentials.must_equal "spanner-credentials"
        timeout.must_be :nil?
        host.must_be :nil?
        client_config.must_be :nil?
        keyword_args.key?(:lib_name).must_equal true
        keyword_args.key?(:lib_version).must_equal true
        keyword_args[:lib_name].must_be :nil?
        keyword_args[:lib_version].must_be :nil?
        OpenStruct.new project: project
      }

      # Clear all environment variables
      ENV.stub :[], nil do
        File.stub :file?, true, ["path/to/keyfile.json"] do
          File.stub :read, found_credentials, ["path/to/keyfile.json"] do
            Google::Cloud::Spanner::Credentials.stub :new, stubbed_credentials do
              Google::Cloud::Spanner::Service.stub :new, stubbed_service do
                spanner = Google::Cloud::Spanner.new project_id: "project-id", credentials: "path/to/keyfile.json"
                spanner.must_be_kind_of Google::Cloud::Spanner::Project
                spanner.project.must_equal "project-id"
                spanner.service.must_be_kind_of OpenStruct
              end
            end
          end
        end
      end
    end

    it "uses provided endpoint" do
      endpoint = "spanner-endpoint2.example.com"
      stubbed_service = ->(project, credentials, timeout: nil, host: nil, client_config: nil, **keyword_args) {
        project.must_equal "project-id"
        credentials.must_equal default_credentials
        timeout.must_be :nil?
        host.must_equal endpoint
        client_config.must_be :nil?
        keyword_args.key?(:lib_name).must_equal true
        keyword_args.key?(:lib_version).must_equal true
        keyword_args[:lib_name].must_be :nil?
        keyword_args[:lib_version].must_be :nil?
        OpenStruct.new project: project
      }

      # Clear all environment variables
      ENV.stub :[], nil do
        Google::Cloud::Spanner::Service.stub :new, stubbed_service do
          spanner = Google::Cloud::Spanner.new project: "project-id", credentials: default_credentials, endpoint: endpoint
          spanner.must_be_kind_of Google::Cloud::Spanner::Project
          spanner.project.must_equal "project-id"
          spanner.service.must_be_kind_of OpenStruct
        end
      end
    end

    it "uses provided project and keyfile aliases" do
      stubbed_credentials = ->(keyfile, scope: nil) {
        keyfile.must_equal "path/to/keyfile.json"
        scope.must_be :nil?
        "spanner-credentials"
      }
      stubbed_service = ->(project, credentials, timeout: nil, host: nil, client_config: nil, **keyword_args) {
        project.must_equal "project-id"
        credentials.must_equal "spanner-credentials"
        timeout.must_be :nil?
        host.must_be :nil?
        client_config.must_be :nil?
        keyword_args.key?(:lib_name).must_equal true
        keyword_args.key?(:lib_version).must_equal true
        keyword_args[:lib_name].must_be :nil?
        keyword_args[:lib_version].must_be :nil?
        OpenStruct.new project: project
      }

      # Clear all environment variables
      ENV.stub :[], nil do
        File.stub :file?, true, ["path/to/keyfile.json"] do
          File.stub :read, found_credentials, ["path/to/keyfile.json"] do
            Google::Cloud::Spanner::Credentials.stub :new, stubbed_credentials do
              Google::Cloud::Spanner::Service.stub :new, stubbed_service do
                spanner = Google::Cloud::Spanner.new project: "project-id", keyfile: "path/to/keyfile.json"
                spanner.must_be_kind_of Google::Cloud::Spanner::Project
                spanner.project.must_equal "project-id"
                spanner.service.must_be_kind_of OpenStruct
              end
            end
          end
        end
      end
    end

    it "gets project_id from credentials" do
      stubbed_credentials = ->(keyfile, scope: nil) {
        keyfile.must_equal "path/to/keyfile.json"
        scope.must_be :nil?
        OpenStruct.new project_id: "project-id"
      }
      stubbed_service = ->(project, credentials, timeout: nil, host: nil, client_config: nil, **keyword_args) {
        project.must_equal "project-id"
        credentials.must_be_kind_of OpenStruct
        credentials.project_id.must_equal "project-id"
        timeout.must_be :nil?
        host.must_be :nil?
        client_config.must_be :nil?
        keyword_args.key?(:lib_name).must_equal true
        keyword_args.key?(:lib_version).must_equal true
        keyword_args[:lib_name].must_be :nil?
        keyword_args[:lib_version].must_be :nil?
        OpenStruct.new project: project
      }
      empty_env = OpenStruct.new

      # Clear all environment variables
      ENV.stub :[], nil do
        Google::Cloud.stub :env, empty_env do
          File.stub :file?, true, ["path/to/keyfile.json"] do
            File.stub :read, found_credentials, ["path/to/keyfile.json"] do
              Google::Cloud::Spanner::Credentials.stub :new, stubbed_credentials do
                Google::Cloud::Spanner::Service.stub :new, stubbed_service do
                  spanner = Google::Cloud::Spanner.new credentials: "path/to/keyfile.json"
                  spanner.must_be_kind_of Google::Cloud::Spanner::Project
                  spanner.project.must_equal "project-id"
                  spanner.service.must_be_kind_of OpenStruct
                end
              end
            end
          end
        end
      end
    end

    it "uses SPANNER_EMULATOR_HOST environment variable" do
      emulator_host = "localhost:4567"
      emulator_check = ->(name) { (name == "SPANNER_EMULATOR_HOST") ? emulator_host : nil }
      # Clear all environment variables, except SPANNER_EMULATOR_HOST
      ENV.stub :[], emulator_check do
        # Get project_id from Google Compute Engine
        Google::Cloud.stub :env, OpenStruct.new(project_id: "project-id") do
          Google::Cloud::Spanner::Credentials.stub :default, default_credentials do
            spanner = Google::Cloud::Spanner.new
            spanner.must_be_kind_of Google::Cloud::Spanner::Project
            spanner.project.must_equal "project-id"
            spanner.service.credentials.must_equal :this_channel_is_insecure
            spanner.service.host.must_equal emulator_host
          end
        end
      end
    end

    it "allows emulator_host to be set" do
      emulator_host = "localhost:4567"
      # Clear all environment variables
      ENV.stub :[], nil do
        # Get project_id from Google Compute Engine
        Google::Cloud.stub :env, OpenStruct.new(project_id: "project-id") do
          Google::Cloud::Spanner::Credentials.stub :default, default_credentials do
            spanner = Google::Cloud::Spanner.new emulator_host: emulator_host
            spanner.must_be_kind_of Google::Cloud::Spanner::Project
            spanner.project.must_equal "project-id"
            spanner.service.credentials.must_equal :this_channel_is_insecure
            spanner.service.host.must_equal emulator_host
          end
        end
      end
    end

    it "uses provided lib name and lib version" do
      lib_name = "spanner-ruby"
      lib_version = "1.0.0"

      # Clear all environment variables
      ENV.stub :[], nil do
        # Get project_id from Google Compute Engine
        Google::Cloud.stub :env, OpenStruct.new(project_id: "project-id") do
          Google::Cloud::Spanner::Credentials.stub :default, default_credentials do
            spanner = Google::Cloud::Spanner.new lib_name: lib_name, lib_version: lib_version
            spanner.must_be_kind_of Google::Cloud::Spanner::Project
            spanner.project.must_equal "project-id"
            spanner.service.lib_name.must_equal lib_name
            spanner.service.lib_version.must_equal lib_version
            spanner.service.send(:lib_name_with_prefix).must_equal "#{lib_name}/#{lib_version} gccl"
          end
        end
      end
    end

    it "uses SPANNER_OPTIMIZER_VERSION environment variable" do
      optimizer_version = "4"
      optimizer_version_check = ->(name) { (name == "SPANNER_OPTIMIZER_VERSION") ? optimizer_version : nil }
      # Clear all environment variables, except SPANNER_OPTIMIZER_VERSION
      ENV.stub :[], optimizer_version_check do
        # Get project_id from Google Compute Engine
        Google::Cloud.stub :env, OpenStruct.new(project_id: "project-id") do
          Google::Cloud::Spanner::Credentials.stub :default, default_credentials do
            spanner = Google::Cloud::Spanner.new
            query_options = {optimizer_version: optimizer_version}
            spanner.query_options.must_equal query_options
          end
        end
      end
    end

    it "uses provided lib name only" do
      lib_name = "spanner-ruby"

      # Clear all environment variables
      ENV.stub :[], nil do
        # Get project_id from Google Compute Engine
        Google::Cloud.stub :env, OpenStruct.new(project_id: "project-id") do
          Google::Cloud::Spanner::Credentials.stub :default, default_credentials do
            spanner = Google::Cloud::Spanner.new lib_name: lib_name
            spanner.must_be_kind_of Google::Cloud::Spanner::Project
            spanner.project.must_equal "project-id"
            spanner.service.lib_name.must_equal lib_name
            spanner.service.lib_version.must_be :nil?
            spanner.service.send(:lib_name_with_prefix).must_equal "#{lib_name} gccl"
          end
        end
      end
    end

    describe "test order of precedence for query options" do
      let(:project_id) { "my-project-id" }
      let(:instance_id) { "my-instance-id" }
      let(:database_id) { "my-database-id" }
      let(:session_id) { "session-1" }
      let(:transaction_id) { "tx789" }
      let(:results_hash) do
        {
          metadata: {
            row_type: {
              fields: [
                { type: { code: :INT64 } }
              ]
            }
          },
          values: [
            { string_value: "1" }
          ]
        }
      end
      let(:results_grpc) { Google::Spanner::V1::PartialResultSet.new results_hash }
      let(:results_enum) { Array(results_grpc).to_enum }
      let(:database_path) { Google::Cloud::Spanner::Admin::Database::V1::DatabaseAdminClient.database_path(project_id, instance_id, database_id) }
      let(:session_path) { Google::Cloud::Spanner::V1::SpannerClient.session_path(project_id, instance_id, database_id, session_id) }
      let(:default_options) { Google::Gax::CallOptions.new kwargs: { "google-cloud-resource-prefix" => database_path } }
      let(:session_grpc) { Google::Spanner::V1::Session.new name: session_path }
      let(:snp_opts) { Google::Spanner::V1::TransactionOptions::ReadOnly.new return_read_timestamp: true }
      let(:tx_opts_read_only) { Google::Spanner::V1::TransactionOptions.new read_only: snp_opts }
      let(:tx_opts_read_write) { Google::Spanner::V1::TransactionOptions.new(read_write: Google::Spanner::V1::TransactionOptions::ReadWrite.new) }
      let(:timestamp) { Google::Protobuf::Timestamp.new seconds: 1412262083, nanos: 45123456 }
      let(:transaction_grpc) { Google::Spanner::V1::Transaction.new id: transaction_id, read_timestamp: timestamp }
      let(:batch_create_sessions_grpc) { Google::Spanner::V1::BatchCreateSessionsResponse.new session: [session_grpc] }
      let(:tx_selector) { Google::Spanner::V1::TransactionSelector.new id: transaction_id }
      let(:commit_time) { Time.now }
      let(:commit_resp) { Google::Spanner::V1::CommitResponse.new commit_timestamp: Google::Cloud::Spanner::Convert.time_to_timestamp(commit_time) }
      let(:expect_query_optimizer_version) { "4" }
      def mock_builder
        # Mock an instance of V1::SpannerClient
        mock = Minitest::Mock.new
        mock.expect :batch_create_sessions, batch_create_sessions_grpc, [
          database_path, 1, session_template: nil, options: default_options
        ]
        mock.expect :execute_streaming_sql, results_enum do |session, sql_query, **kargs|
          session == session_grpc.name &&
            sql_query == "SELECT * FROM users" &&
            kargs[:query_options] == {optimizer_version: expect_query_optimizer_version}
        end
        mock
      end

      it "follows that environment variables take over client-level config" do	
        optimizer_version_check = ->(name) { (name == "SPANNER_OPTIMIZER_VERSION") ? expect_query_optimizer_version : nil }
        # Clear all environment variables, except SPANNER_OPTIMIZER_VERSION
        ENV.stub :[], optimizer_version_check do
          # Get project_id from Google Compute Engine
          Google::Cloud.stub :env, OpenStruct.new(project_id: project_id) do
            Google::Cloud::Spanner::Credentials.stub :default, default_credentials do
              spanner = Google::Cloud::Spanner.new
              spanner.service.mocked_service = mock_builder()
              
              client = spanner.client instance_id, database_id, pool: { min: 1, max: 1 }, query_options: { optimizer_version: "3" }
              client.execute_query "SELECT * FROM users"
            end
          end
        end
      end

      it "follows that query-level config take over environment variables" do
        env_var_version = "3"
        optimizer_version_check = ->(name) { (name == "SPANNER_OPTIMIZER_VERSION") ? env_var_version : nil }
        # Clear all environment variables, except SPANNER_OPTIMIZER_VERSION
        ENV.stub :[], optimizer_version_check do
          # Get project_id from Google Compute Engine
          Google::Cloud.stub :env, OpenStruct.new(project_id: project_id) do
            Google::Cloud::Spanner::Credentials.stub :default, default_credentials do
              spanner = Google::Cloud::Spanner.new

              spanner.service.mocked_service = mock_builder()
              client = spanner.client instance_id, database_id, pool: { min: 1, max: 1 }
              client.execute_query "SELECT * FROM users", query_options: { optimizer_version: expect_query_optimizer_version }

              mock = mock_builder()
              spanner.service.mocked_service = mock
              mock.expect :begin_transaction, transaction_grpc, [session_grpc.name, tx_opts_read_only, options: default_options]
              client.snapshot do |snp|
                snp.execute_query "SELECT * FROM users", query_options: { optimizer_version: expect_query_optimizer_version }
              end

              mock = mock_builder()
              spanner.service.mocked_service = mock
              mock.expect :begin_transaction, transaction_grpc, [session_grpc.name, tx_opts_read_write, options: default_options]
              mock.expect :commit, commit_resp, [session_grpc.name, [], transaction_id: transaction_id, single_use_transaction: nil, options: default_options]
              client.transaction do |tx|
                tx.execute_query "SELECT * FROM users", query_options: { optimizer_version: expect_query_optimizer_version }
              end
            end
          end
        end
      end

      it "follows that query-level config take over client-level config" do
        # Get project_id from Google Compute Engine
        Google::Cloud.stub :env, OpenStruct.new(project_id: project_id) do
          Google::Cloud::Spanner::Credentials.stub :default, default_credentials do
            spanner = Google::Cloud::Spanner.new

            spanner.service.mocked_service = mock_builder()
            client = spanner.client instance_id, database_id, pool: { min: 1, max: 1 }, query_options: { optimizer_version: "3" }
            client.execute_query "SELECT * FROM users", query_options: { optimizer_version: expect_query_optimizer_version }

            mock = mock_builder()
            spanner.service.mocked_service = mock
            mock.expect :begin_transaction, transaction_grpc, [session_grpc.name, tx_opts_read_only, options: default_options]
            client.snapshot do |snp|
              snp.execute_query "SELECT * FROM users", query_options: { optimizer_version: expect_query_optimizer_version }
            end

            mock = mock_builder()
            spanner.service.mocked_service = mock
            mock.expect :begin_transaction, transaction_grpc, [session_grpc.name, tx_opts_read_write, options: default_options]
            mock.expect :commit, commit_resp, [session_grpc.name, [], transaction_id: transaction_id, single_use_transaction: nil, options: default_options]
            client.transaction do |tx|
              tx.execute_query "SELECT * FROM users", query_options: { optimizer_version: expect_query_optimizer_version }
            end
          end
        end
      end
    end
  end

  describe "Spanner.configure" do
    let(:default_credentials) do
      ->(keyfile, scope: nil) {
        keyfile.must_equal "path/to/keyfile.json"
        scope.must_be :nil?
        "spanner-credentials"
      }
    end
    let(:found_credentials) { "{}" }
    let :spanner_client_config do
      {"interfaces"=>
        {"google.spanner.v1.Spanner"=>
          {"retry_codes"=>{"idempotent"=>["DEADLINE_EXCEEDED", "UNAVAILABLE"]}}}}
    end

    after do
      Google::Cloud.configure.reset!
    end

    it "uses shared config for project and keyfile" do
      stubbed_service = ->(project, credentials, timeout: nil, host: nil, client_config: nil, **keyword_args) {
        project.must_equal "project-id"
        credentials.must_equal "spanner-credentials"
        timeout.must_be :nil?
        host.must_be :nil?
        client_config.must_be :nil?
        keyword_args.key?(:lib_name).must_equal true
        keyword_args.key?(:lib_version).must_equal true
        keyword_args[:lib_name].must_be :nil?
        keyword_args[:lib_version].must_be :nil?
        OpenStruct.new project: project
      }

      # Clear all environment variables
      ENV.stub :[], nil do
        # Set new configuration
        Google::Cloud.configure do |config|
          config.project = "project-id"
          config.keyfile = "path/to/keyfile.json"
        end

        File.stub :file?, true, ["path/to/keyfile.json"] do
          File.stub :read, found_credentials, ["path/to/keyfile.json"] do
            Google::Cloud::Spanner::Credentials.stub :new, default_credentials do
              Google::Cloud::Spanner::Service.stub :new, stubbed_service do
                spanner = Google::Cloud::Spanner.new
                spanner.must_be_kind_of Google::Cloud::Spanner::Project
                spanner.project.must_equal "project-id"
                spanner.service.must_be_kind_of OpenStruct
              end
            end
          end
        end
      end
    end

    it "uses shared config for project_id and credentials" do
      stubbed_service = ->(project, credentials, timeout: nil, host: nil, client_config: nil, **keyword_args) {
        project.must_equal "project-id"
        credentials.must_equal "spanner-credentials"
        timeout.must_be :nil?
        host.must_be :nil?
        client_config.must_be :nil?
        keyword_args.key?(:lib_name).must_equal true
        keyword_args.key?(:lib_version).must_equal true
        keyword_args[:lib_name].must_be :nil?
        keyword_args[:lib_version].must_be :nil?
        OpenStruct.new project: project
      }

      # Clear all environment variables
      ENV.stub :[], nil do
        # Set new configuration
        Google::Cloud.configure do |config|
          config.project_id = "project-id"
          config.credentials = "path/to/keyfile.json"
        end

        File.stub :file?, true, ["path/to/keyfile.json"] do
          File.stub :read, found_credentials, ["path/to/keyfile.json"] do
            Google::Cloud::Spanner::Credentials.stub :new, default_credentials do
              Google::Cloud::Spanner::Service.stub :new, stubbed_service do
                spanner = Google::Cloud::Spanner.new
                spanner.must_be_kind_of Google::Cloud::Spanner::Project
                spanner.project.must_equal "project-id"
                spanner.service.must_be_kind_of OpenStruct
              end
            end
          end
        end
      end
    end

    it "uses spanner config for project and keyfile" do
      stubbed_service = ->(project, credentials, timeout: nil, host: nil, client_config: nil, **keyword_args) {
        project.must_equal "project-id"
        credentials.must_equal "spanner-credentials"
        timeout.must_equal 42
        host.must_be :nil?
        client_config.must_equal spanner_client_config
        keyword_args.key?(:lib_name).must_equal true
        keyword_args.key?(:lib_version).must_equal true
        keyword_args[:lib_name].must_be :nil?
        keyword_args[:lib_version].must_be :nil?
        OpenStruct.new project: project
      }

      # Clear all environment variables
      ENV.stub :[], nil do
        # Set new configuration
        Google::Cloud::Spanner.configure do |config|
          config.project = "project-id"
          config.keyfile = "path/to/keyfile.json"
          config.timeout = 42
          config.client_config = spanner_client_config
        end

        File.stub :file?, true, ["path/to/keyfile.json"] do
          File.stub :read, found_credentials, ["path/to/keyfile.json"] do
            Google::Cloud::Spanner::Credentials.stub :new, default_credentials do
              Google::Cloud::Spanner::Service.stub :new, stubbed_service do
                spanner = Google::Cloud::Spanner.new
                spanner.must_be_kind_of Google::Cloud::Spanner::Project
                spanner.project.must_equal "project-id"
                spanner.service.must_be_kind_of OpenStruct
              end
            end
          end
        end
      end
    end

    it "uses spanner config for project_id and credentials" do
      stubbed_service = ->(project, credentials, timeout: nil, host: nil, client_config: nil, **keyword_args) {
        project.must_equal "project-id"
        credentials.must_equal "spanner-credentials"
        timeout.must_equal 42
        host.must_be :nil?
        client_config.must_equal spanner_client_config
        keyword_args.key?(:lib_name).must_equal true
        keyword_args.key?(:lib_version).must_equal true
        keyword_args[:lib_name].must_be :nil?
        keyword_args[:lib_version].must_be :nil?
        OpenStruct.new project: project
      }

      # Clear all environment variables
      ENV.stub :[], nil do
        # Set new configuration
        Google::Cloud::Spanner.configure do |config|
          config.project_id = "project-id"
          config.credentials = "path/to/keyfile.json"
          config.timeout = 42
          config.client_config = spanner_client_config
        end

        File.stub :file?, true, ["path/to/keyfile.json"] do
          File.stub :read, found_credentials, ["path/to/keyfile.json"] do
            Google::Cloud::Spanner::Credentials.stub :new, default_credentials do
              Google::Cloud::Spanner::Service.stub :new, stubbed_service do
                spanner = Google::Cloud::Spanner.new
                spanner.must_be_kind_of Google::Cloud::Spanner::Project
                spanner.project.must_equal "project-id"
                spanner.service.must_be_kind_of OpenStruct
              end
            end
          end
        end
      end
    end

    it "uses spanner config for endpoint" do
      endpoint = "spanner-endpoint2.example.com"
      stubbed_service = ->(project, credentials, timeout: nil, host: nil, client_config: nil, **keyword_args) {
        project.must_equal "project-id"
        credentials.must_equal "spanner-credentials"
        timeout.must_be :nil?
        host.must_equal endpoint
        client_config.must_be :nil?
        keyword_args.key?(:lib_name).must_equal true
        keyword_args.key?(:lib_version).must_equal true
        keyword_args[:lib_name].must_be :nil?
        keyword_args[:lib_version].must_be :nil?
        OpenStruct.new project: project
      }

      # Clear all environment variables
      ENV.stub :[], nil do
        # Set new configuration
        Google::Cloud::Spanner.configure do |config|
          config.project = "project-id"
          config.keyfile = "path/to/keyfile.json"
          config.endpoint = endpoint
        end

        File.stub :file?, true, ["path/to/keyfile.json"] do
          File.stub :read, found_credentials, ["path/to/keyfile.json"] do
            Google::Cloud::Spanner::Credentials.stub :new, default_credentials do
              Google::Cloud::Spanner::Service.stub :new, stubbed_service do
                spanner = Google::Cloud::Spanner.new
                spanner.must_be_kind_of Google::Cloud::Spanner::Project
                spanner.project.must_equal "project-id"
                spanner.service.must_be_kind_of OpenStruct
              end
            end
          end
        end
      end
    end

    it "uses spanner config for emulator_host" do
      # Clear all environment variables
      ENV.stub :[], nil do
        # Set new configuration
        Google::Cloud::Spanner.configure do |config|
          config.project_id = "project-id"
          config.keyfile = "path/to/keyfile.json"
          config.emulator_host = "localhost:4567"
        end

        spanner = Google::Cloud::Spanner.new
        spanner.must_be_kind_of Google::Cloud::Spanner::Project
        spanner.project.must_equal "project-id"
        spanner.service.credentials.must_equal :this_channel_is_insecure
        spanner.service.host.must_equal "localhost:4567"
      end
    end

    it "uses spanner config for custom lib name and version" do
      custom_lib_name = "spanner-ruby"
      custom_lib_version = "1.0.0"

      stubbed_credentials = ->(keyfile, scope: nil) {
        scope.must_be :nil?
        "spanner-credentials"
      }
      stubbed_service = ->(project, credentials, timeout: nil, host: nil, client_config: nil, **keyword_args) {
        project.must_equal "project-id"
        credentials.must_equal "spanner-credentials"
        timeout.must_be :nil?
        host.must_be :nil?
        client_config.must_be :nil?
        keyword_args[:lib_name].must_equal custom_lib_name
        keyword_args[:lib_version].must_equal custom_lib_version
        OpenStruct.new project: project, lib_name: keyword_args[:lib_name], lib_version: keyword_args[:lib_version]
      }

      # Clear all environment variables
      ENV.stub :[], nil do
        # Set new configuration
        Google::Cloud::Spanner.configure do |config|
          config.project = "project-id"
          config.keyfile = "path/to/keyfile.json"
          config.lib_name = custom_lib_name
          config.lib_version = custom_lib_version
        end

        File.stub :file?, true, ["path/to/keyfile.json"] do
          File.stub :read, found_credentials, ["path/to/keyfile.json"] do
            Google::Cloud::Spanner::Credentials.stub :new, stubbed_credentials do
              Google::Cloud::Spanner::Service.stub :new, stubbed_service do
                spanner = Google::Cloud::Spanner.new
                spanner.must_be_kind_of Google::Cloud::Spanner::Project
                spanner.project.must_equal "project-id"
                spanner.service.must_be_kind_of OpenStruct
                spanner.service.lib_name.must_equal custom_lib_name
                spanner.service.lib_version.must_equal custom_lib_version
              end
            end
          end
        end
      end
    end

    it "uses spanner config for query_options" do
      query_options = {optimizer_version: "4"}
      # Clear all environment variables
      ENV.stub :[], nil do
        # Set new configuration
        Google::Cloud::Spanner.configure do |config|
          config.project_id = "project-id"
          config.keyfile = "path/to/keyfile.json"
          config.query_options = query_options
        end

        File.stub :file?, true, ["path/to/keyfile.json"] do
          File.stub :read, found_credentials, ["path/to/keyfile.json"] do
            Google::Cloud::Spanner::Credentials.stub :new, default_credentials do
              spanner = Google::Cloud::Spanner.new
              spanner.project.must_equal "project-id"
              spanner.query_options.must_equal query_options
            end
          end
        end
      end
    end
  end
end
