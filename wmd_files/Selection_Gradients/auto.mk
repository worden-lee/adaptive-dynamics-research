auto.seq.Rout: input.Rout auto.R
	$(run-R)

auto.Rout: input.R auto.R
	$(run-R)
