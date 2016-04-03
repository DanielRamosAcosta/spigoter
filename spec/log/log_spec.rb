require 'spec_helper'


describe Log do
    it "Se debe poder llamar al Log con informacion" do
        Log.info "Informacion"
        expect(@log_output.readline).to eq " INFO  Spigoter : Informacion\n"
    end
    it "Se debe poder llamar al Log con avisos" do
        Log.warn "Aviso"
        expect(@log_output.readline).to eq " WARN  Spigoter : Aviso\n"
    end
    it "Se debe poder llamar al Log con errores" do
        Log.error "Error"
        expect(@log_output.readline).to eq "ERROR  Spigoter : Error\n"
    end
end
