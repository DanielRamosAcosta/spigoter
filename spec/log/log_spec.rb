require 'spec_helper'

describe Log do
  it 'Se debe poder llamar al Log con informacion' do
    silence_stream(STDOUT) do
      Log.info 'Informacion'
    end
    expect(@log_output.readline).to eq " INFO  Spigoter : Informacion\n"
  end
  it 'Se debe poder llamar al Log con avisos' do
    silence_stream(STDOUT) do
      Log.warn 'Aviso'
    end
    expect(@log_output.readline).to eq " WARN  Spigoter : Aviso\n"
  end
  it 'Se debe poder llamar al Log con errores' do
    silence_stream(STDOUT) do
      Log.error 'Error'
    end
    expect(@log_output.readline).to eq "ERROR  Spigoter : Error\n"
  end
end
