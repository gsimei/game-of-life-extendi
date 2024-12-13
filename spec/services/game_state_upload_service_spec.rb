require 'rails_helper'

##
# Test suite for the GameStateUploadService.
#
# This test suite validates the functionality of the GameStateUploadService,
# ensuring that it correctly processes and parses the uploaded game state files.
#
# @example Run this test suite with:
#   bundle exec rspec spec/services/game_state_upload_service_spec.rb
RSpec.describe GameStateUploadService do
  let(:valid_file) { fixture_file_upload('spec/fixtures/files/valid_file.txt', 'text/plain').read }
  let(:empty_file) { fixture_file_upload('spec/fixtures/files/empty_file.txt', 'text/plain').read }
  let(:missing_generation) { fixture_file_upload('spec/fixtures/files/missing_generation.txt', 'text/plain').read }
  let(:missing_dimensions) { fixture_file_upload('spec/fixtures/files/missing_dimensions.txt', 'text/plain').read }
  let(:mismatched_grid) { fixture_file_upload('spec/fixtures/files/mismatched_grid.txt', 'text/plain').read }
  let(:invalid_columns) { fixture_file_upload('spec/fixtures/files/invalid_columns.txt', 'text/plain').read }

  describe "#call" do
    context "with valid input" do
      ##
      # Validates that the service correctly parses a valid file.
      #
      # @example Test output:
      #   result[:generation] => 3
      #   result[:rows] => 4
      #   result[:cols] => 4
      #   result[:state] => [
      #     [ ".", ".", ".", "." ],
      #     [ ".", "*", "*", "." ],
      #     [ ".", "*", "*", "." ],
      #     [ ".", ".", ".", "." ]
      #   ]
      it "parses the file and returns the correct attributes" do
        service = described_class.new(valid_file)
        result = service.call

        expect(result[:generation]).to eq(3)
        expect(result[:rows]).to eq(4)
        expect(result[:cols]).to eq(4)
        expect(result[:state]).to eq([
          [ ".", ".", ".", "." ],
          [ ".", "*", "*", "." ],
          [ ".", "*", "*", "." ],
          [ ".", ".", ".", "." ]
        ])
      end
    end

    context "when file is empty" do
      ##
      # Validates that the service raises an error for an empty file.
      #
      # @example Test output:
      #   raises_error("File is empty or invalid")
      it "raises an error for an empty file" do
        service = described_class.new(empty_file)
        expect { service.call }.to raise_error("File is empty or invalid")
      end
    end

    context "when generation line is missing" do
      ##
      # Validates that the service raises an error for a missing generation line.
      #
      # @example Test output:
      #   raises_error("Missing or malformed generation line")
      it "raises an error for missing generation line" do
        service = described_class.new(missing_generation)
        expect { service.call }.to raise_error("Missing or malformed generation line")
      end
    end

    context "when dimensions line is missing" do
      ##
      # Validates that the service raises an error for a missing dimensions line.
      #
      # @example Test output:
      #   raises_error("Missing or malformed dimensions line")
      it "raises an error for missing dimensions line" do
        service = described_class.new(missing_dimensions)
        expect { service.call }.to raise_error("Missing or malformed dimensions line")
      end
    end

    context "when grid does not match dimensions" do
      ##
      # Validates that the service raises an error when the grid size does not match the dimensions.
      #
      # @example Test output:
      #   raises_error("Grid dimensions do not match the specified rows and columns")
      it "raises an error when the grid size does not match the dimensions" do
        service = described_class.new(mismatched_grid)
        expect { service.call }.to raise_error("Grid dimensions do not match the specified rows and columns")
      end
    end

    context "when rows have incorrect column sizes" do
      ##
      # Validates that the service raises an error when rows have inconsistent column sizes.
      #
      # @example Test output:
      #   raises_error("Grid dimensions do not match the specified rows and columns")
      it "raises an error when rows have inconsistent column sizes" do
        service = described_class.new(invalid_columns)
        expect { service.call }.to raise_error("Grid dimensions do not match the specified rows and columns")
      end
    end
  end
end
