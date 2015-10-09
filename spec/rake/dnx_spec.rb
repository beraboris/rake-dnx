MAIN_OBJECT = self

describe Rake::Dnx do
  it 'should have a version number' do
    expect(Rake::Dnx::VERSION).not_to be nil
  end

  it 'should inject itself into the main object' do
    expect(MAIN_OBJECT).to respond_to :dnx
    expect(MAIN_OBJECT).to respond_to :dnu
    expect(MAIN_OBJECT).to respond_to :dnx_discover
  end
end
