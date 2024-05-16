# Lower Stratosphere Chemistry Equilibrium Model

## Basic information

This model is a chemical equilibrium model for the lower stratosphere. It currently is setup to conserve CL, BR, and N, at 45S. HOx species are not conserved, but should be fine over the course of a year. It reads in pre-tabulated photolysis data outputed every 15 mins for 45S using TUV code. Initial variable concentrations are from CESM1-CARMA 2020 values. It can be run for any altitude, but results will likley be incorrect if used below ~16 km or above ~25 km.

variables that are currently simulated are: O3, O3P (as O), O1D, CLONO2, HCL, HOCL, CLO, CL2, CL2O2, OCLO, CL, BRCL, NO2, NO, NO3, N2O5, HO2NO2, OH, HO2, H2O2, HNO3 ,BRO ,HOBR, HBR, BRONO2, and BR. 

climatology species that are used in rates calculations but not solved for are: O2, N2, CH4, N2O, CH2O, CH3O2, H2, and CO.

Methane oxidation species can also be simulated (but turned off by default). This adds in CH2O, CH3O2, CH3OH, and CH3OOH. So CH2O and CH3O2 climatology values are no longer used

The iterative implicit solver follows the Raphson-Newton tangent line approximation method.

## User inputs

Most user inputs can be set in runinputs.m, so information is provided below

**Startdate**: The start year is irrelevant (2017 was chosen to allow 365 day year for day of year calculations)

**Hourstep**: This is the timestep used in the solver (default is 15 mins). If a different timestep is chosen the closest time matching photolysis values will be used. If methane oxidation chemistry is currently turned on the timestep will default to 5 mins.

**Altitude**: choose altitude to analyze here

**Region**: Code only has midlatitude region at the moment. May put in polar region in the future

**Whichphoto**: you can choose either 'load' or 'inter'. Only choose inter if you want to recalculate photolysis values for a different latitude region or if you want to debug photolysis rates. Recalculating photolysis will take a long time (4-6 hours) and will require fortran to be installed and recompilation of TUV.f in TUV5.4.

**evolvingJ**: if set to 1 will recalculate the Jacobian on every iteration of solver. This is more accurate, but will slow down the code substantially and isn't really needed, so default is 0.

**maxiterations**: (Default: 50). If solver doesnt converge after 50 iterations it will throw and error. Ideally if this happens the solver will half the time step and repeat (this has not been implemented yet)

**runtype**: This is the string identifier for control or sensitivity simulations. current options are: 'control', 'solubility', and 'doublelinear'. 

**radius**: Can set constant radius for heterogeneous chemistry here or use time evolving radius from input files

**methanechemsitry**: (default: 0, off) Turn methane oxidation chemistry on or off. 

**fluxcorrections**: This can be used to relax longer lived tracers to climatology for the control run,, and then add those values (as a percent) for sensitivity simulations. Caution should be taken when using this for sensitivity simulations.

**outputrates**: output and save all rates values

## Hunga-Tonga runcase information
inputs.runcase = 'Hunga' will input a pulse of H2O, SAD, and double the aerosol radius on June first used for testing gamma hobr and gamma hcl considerations for the HOBR+HCL heterogeneous reaction.

This is currently setup for 21 km at 45˚S. Using other altitudes will require new input anomalies for H2O, and SAD based of Jun et al. (2024) Figure 4d. Temperature data for other altitudes will also need to be input-currently uses interpolated 2022 monthly 21 km values from the specified dynamics output from Jun et al. (2024). Any new inputs for the Hunga case will need to be hard coded in initializevars.m 'Hunga' case.

To test different gamma hcl and gamma hobr setups, in runinputs.m, inputs.HOBR has the option of choosing Waschewsky-Abbatt experimental values (inputs.HOBR = 'WA') or Hanson values (inputs.HOBR = 'Hanson'). inputs.ghobr gives the option of choosing to calculate gamma hobr or gamma hcl based on WA or Hanson values.

a control run can performed by setting inputs.runcase = 'control' using the appopriate inputs.ghobr and inputs.HOBR for heterogeneous HOBR+HCL testing.

## Add in new species

Instructions for adding in new species.

* Add in photolysis production and destrction terms in photolysis.m 
  * photolysis reactions available can be found by running TUVnamelist.m
* Add in gas phase rates equations in gasphaserates.m (this is only run once a day because daily temperature averages are used)
  * gas phase rates: k * [y1] * [y2] need to be added in gasphasecontrol.m and then assigned to production or destruction of effected species
* heterogeneous rates need to be added in hetcontrol and hetrates.

   

