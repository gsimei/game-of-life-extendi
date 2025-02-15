RSpec.describe JwtDenylist, type: :model do
  describe 'validations' do
    it 'valida presença de jti' do
      record = described_class.new(exp: Time.now.to_i)

      expect(record).not_to be_valid
      expect(record.errors[:jti]).to include("can't be blank")
    end

    it 'valida presença de exp' do
      record = described_class.new(jti: 'random_jti')

      expect(record).not_to be_valid
      expect(record.errors[:exp]).to include("can't be blank")
    end
  end
end
