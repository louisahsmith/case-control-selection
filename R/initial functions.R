
# enter probabilities of exposure, observed data, total cases/controls
pr_exposure <- list(cases = 0.29, controls = 0.25)
raw_data <- list(exposed_cases = 97, unexposed_cases = 288, 
                 exposed_controls = 965, unexposed_controls = 2726)
total_cc <- list(cases = 692, controls = 6381)


#####
pr_exposure_cases <- total_data$exposed_cases / (total_data$exposed_cases + total_data$unexposed_cases)
pr_exposure_controls <- total_data$exposed_controls / (total_data$exposed_controls + total_data$unexposed_controls)

# get total data, selection fractions, corrected OR
total_data <- list(exposed_cases = total_cc$cases * pr_exposure$cases, 
                   unexposed_cases = total_cc$cases * (1 - pr_exposure$cases), 
                   exposed_controls =  total_cc$controls * pr_exposure$controls, 
                   unexposed_controls = total_cc$controls * (1 - pr_exposure$controls))
selection_fractions <- as.list(unlist(raw_data) / unlist(total_data))
or_corrected <- (total_data$exposed_cases * total_data$unexposed_controls) / 
  (total_data$exposed_controls * total_data$unexposed_cases)

### functions

total_data_from_total_cc_pr_exposure <- function(raw_data, total_cc, pr_exposure) {
  list(exposed_cases = total_cc$cases * pr_exposure$cases, 
       unexposed_cases = total_cc$cases * (1 - pr_exposure$cases), 
       exposed_controls =  total_cc$controls * pr_exposure$controls, 
       unexposed_controls = total_cc$controls * (1 - pr_exposure$controls))
}

total_data_from_selection_fractions <- function(raw_data, selection_fractions) {
  list(exposed_cases = raw_data$exposed_cases * selection_fractions$exposed_cases, 
       unexposed_cases = raw_data$unexposed_cases * selection_fractions$unexposed_cases, 
       exposed_controls =  raw_data$exposed_controls * selection_fractions$exposed_controls, 
       unexposed_controls = raw_data$unexposed_controls * selection_fractions$unexposed_controls)
}

selection_fractions_from_total_data <- function(raw_data, total_data) {
  as.list(unlist(raw_data) / unlist(total_data))
}

corrected_or_from_total_data <- function(raw_data = NULL, total_data) {
  (total_data$exposed_cases * total_data$unexposed_controls) / 
    (total_data$exposed_controls * total_data$unexposed_cases)
}

pr_exposure_from_total_data <- function(raw_data = NULL, total_data) {
  list(cases = total_data$exposed_cases / (total_data$exposed_cases + total_data$unexposed_cases), 
       controls = total_data$exposed_controls + total_data$unexposed_controls)
}

total_cc_from_total_data <- function(raw_data = NULL, total_data) {
  list(cases = total_data$exposed_cases + total_data$unexposed_cases, 
       controls = total_data$exposed_controls + total_data$unexposed_controls)
}

selection_cc_from_total_cc <- function(raw_data, total_cc) {
  list(cases = (raw_data$exposed_cases + raw_data$unexposed_cases) / total_cc$cases,
       controls = (raw_data$exposed_controls + raw_data$unexposed_controls) / total_cc$controls)
}

observed_or <- function(raw_data) {
  (raw_data$exposed_cases * raw_data$unexposed_controls) / 
    (raw_data$exposed_controls * raw_data$unexposed_cases)
}

# start with total data
total_cc <- total_cc_from_total_data(raw_data = raw_data, total_data = total_data)
total_cc$cases
total_cc$controls

selection_cc <- selection_cc_from_total_cc(raw_data = raw_data, total_cc = total_cc)
selection_cc$cases
selection_cc$controls

pr_exposure <- pr_exposure_from_total_data(raw_data = raw_data, total_data = total_data)
pr_exposure$cases
pr_exposure$controls

selection_fractions <- selection_fractions_from_total_data(raw_data = raw_data, total_data = total_data)
selection_fractions$exposed_cases
selection_fractions$unexposed_cases
selection_fractions$exposed_controls
selection_fractions$unexposed_controls

corrected_or <- corrected_or_from_total_data(raw_data = raw_data, total_data = total_data)
corrected_or

observed_or(raw_data = raw_data)


# start with selection fractions
total_data <- total_data_from_selection_fractions(raw_data = raw_data, total_data = total_data)

# start with pr exposure and total cc
total_data <- total_data_from_total_cc_pr_exposure(raw_data, total_cc, pr_exposure)

# start with corrected or and total cc 

observed_or(raw_data = raw_data) / corrected_or # = selection bias
selection_fraction_ratio_cases / selection_fraction_ratio_controls

selection_fractions_from_total_data <- function(raw_data, total_data) {
  as.list(unlist(raw_data) / unlist(total_data))
}



###### need to figure out what constraints are
raw_data$exposed_cases # a
raw_data$unexposed_cases # b
raw_data$exposed_controls # c
raw_data$unexposed_controls # d

observed_or # ad / bc = o

total_data$exposed_cases # A
total_data$unexposed_cases # B
total_data$exposed_controls # C
total_data$unexposed_controls # D

corrected_or # AD / BC = z

total_cc$cases # A + B = x
total_cc$controls # C + D = y

selection_fractions$exposed_cases # a / A = p
selection_fractions$unexposed_cases # b / B = q
selection_fractions$exposed_controls # c / C = r
selection_fractions$unexposed_controls # d / D = s

pr_exposure$cases # A / (A + B) = v
pr_exposure$controls # C / (C + D) = w

selection_cc$cases # (a + b) / (A + B) = t
selection_cc$controls # (c + d) / (C + D) = u



