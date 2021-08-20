library(tidyverse)
library(gridExtra)
library(tidyquant)
library(timetk)
library(sweep)
library(forecast)
library(corrplot)
library(highcharter) # for mapping
library(PerformanceAnalytics)
library(heatmaply)

# FUNCTIONS DEFINITIONS

## R SQUARED FUNCTION


rsq <- function(x,y) cor(x,y, use = 'pairwise.complete.obs')^2

get.rsq <- 
  function (df, nl, suf) {
    to.return <-  list()
    rec.var <- paste0('recovered',suf)
    for (name in nl){
      temp = rsq(df[,name], 
                 df[,rec.var])
      to.return[[name]] <- temp[1]
    }
    return(as_tibble(to.return))
  }





proj.dir <- getwd()
data.dir <- 'Datasets'

# DATA IMPORT
stateCovid <- read.csv(file = file.path(proj.dir, data.dir, "state_covid_data.csv"))
stateCovid <- stateCovid %>%
  mutate(date = lubridate::ymd(date))

states <- stateCovid[,"state"] %>% unique()

stateCovid['month'] <- month(stateCovid$date)

stateCovid['week'] <- week(stateCovid$date)

summary(stateCovid$week)

stateCovid %>% group_by(week)


heatmaply_na(
  stateCovid %>% filter(state == 'FL'),
  showticklabels = c(TRUE, FALSE)
)



# DATA QUALITY ANALYSIS
#This looks at what variable are most complete per state


v.list <-  list()

for (st in states){
  
  temp <- stateCovid %>% filter(state == st)
  variables <-  names(temp)
  n <- length(temp[,1])
  sel <-  vector()
  for (v in variables) {
    col <- temp %>% filter(!is.na(temp[,v]) & month > 1 & month < 11)
    c <- length(col[,v])
    if (c/n > 0.75) {
      sel <- append(sel, v)
    }
  }
  v.list[[st]] <- sel
}

v.list[['NY']]

min(stateCovid$date)
max(stateCovid$date)







 
# 
# # TOTAL DEATH COUNT BY MONTH
# stateCovid.Monthly <- stateCovid %>%
#   mutate(month = month(date, label=TRUE)) %>%
#   group_by(month) %>%
#   summarise(totalDeaths = sum(deathIncrease, na.rm=T))
# stateCovid.Monthly
# 
# plot(stateCovid.Monthly)
# ggplot(stateCovid.Monthly, aes(month,totalDeaths/(10**3))) + 
#   geom_bar(stat = 'identity', fill="royalblue4") +
#   theme(plot.title = element_text(hjust = 0.5)) +
#   ggtitle("Total COVID-related Deaths by Month (thousands)") +
#   xlab(NULL) +
#   ylab(NULL)
# 
# northeast.abb <- c("ME", "NH", "VT", "MA", "RI", "CT", "NY", "PA", "NJ")
# midwest.abb <- c("WI", "MI", "IL", "IN", "OH", "ND", "SD", "NE", "KS", "MN", "IA", "MO")
# south.abb <- c("DE", "MD" ,"DC", "VA", "WV", "NC","SC","GA","FL","KY","TN","MS", "AL", "OK", "TX", "AR", "LA")
# west.abb <- c("ID","MT","WY","NV","UT","CO","AZ","NM","AK","WA","OR","CA","HI")
# 
# # Checking all states are accounted for:
# # length(northeast.abb)+length(midwest.abb)+length(south.abb)+length(west.abb)
# 
# 
# 
# # SUBSETTING COVID DATASET BY REGION
# northeast <- stateCovid[stateCovid$state %in% northeast.abb,]
# midwest <- stateCovid[stateCovid$state %in% midwest.abb,]
# south <- stateCovid[stateCovid$state %in% south.abb,]
# west <- stateCovid[stateCovid$state %in% west.abb,]
# 
# 
# stateCovid %>% filter(!is.na(recovered)) %>% 
#   group_by(state) %>%  summarise_at(vars(recovered), funs(sum)) %>% 
#   ggplot(aes(x=state, y=recovered)) +
#   geom_col() + labs(title = 'Total recovered by state')
# 
# stateCovid %>% filter(!is.na(positive)) %>% 
#   group_by(state) %>%  summarise_at(vars(positive), funs(sum)) %>% 
#   ggplot(aes(x=state, y=positive)) +
#   geom_col() + labs(title = 'Total positive by state')
# 
# stateCovid %>% filter(!is.na(death)) %>% 
#   group_by(state) %>%  summarise_at(vars(death), funs(sum)) %>% 
#   ggplot(aes(x=state, y=death)) + 
#   geom_col() + labs(title = 'Total death by state')
# 
# 
# # CORRELLATION DATA AND PLOT
# 
# res <- 
# stateCovid %>% select(where(is.numeric)) %>% 
#   cor(use = 'pairwise.complete.obs')
# 
# res[is.na(res)] <- 0
# 
# col<- colorRampPalette(c("blue", "white", "red"))(20)
# heatmap(x = res, col = col, symm = TRUE)
# 
# potential <- res['recovered',res[,'recovered'] > 0.5 | res[,'recovered'] < -0.5]
# 
# 
# # POTENTIAL VARIABLES
# pos.or.neg.cor <- 
# c('inIcuCumulative', 'positiveTestsPeopleAntigen', 'totalTestsAntigen', 'positive', 
#   'positiveTestsAntibody', 'positiveTestsViral', 'totalTestResults', 'totalTestsViral', 
#   'negative', 'negativeTestsViral', 'positiveCasesViral', 'positiveTestsAntigen',
#   'totalTestsPeopleAntigen', 'onVentilatorCumulative', 'positiveIncrease', 
#   'totalTestEncountersViral', 'totalTestsAntibody', 'totalTestsPeopleViral')
# 
# 
# # PLOTS OF VARIABLES
# stateCovid %>%  
#   gather(pos.or.neg.cor, key = 'var', value = 'val') %>% 
#   filter(!is.na(val) & !is.na(recovered)) %>% 
#   select(state, var, val, recovered) %>% 
#   ggplot(aes(y = recovered, x = val)) +
#   facet_wrap(~ var, scales = 'free') + 
#   geom_point(aes(color = state)) + 
#   geom_smooth(method = 'lm')
# 
# stateCovid %>%  
#   gather(pos.or.neg.cor, key = 'var', value = 'val') %>% 
#   filter(!is.na(val) & !is.na(recovered) & state == 'NY') %>% 
#   select(state, var, val, recovered) %>% 
#   ggplot(aes(y = recovered, x = val)) +
#   facet_wrap(~ var, scales = 'free') + 
#   geom_point(aes(color = state)) + 
#   geom_smooth(method = 'lm')
# 
# 
# states <- stateCovid[,"state"] %>% unique()
# 
# stateCovid['month'] <- month(stateCovid$date)
# 
# stateCovid.summary <- 
# stateCovid %>% group_by(state, month) %>% 
#   summarise_if(is.numeric, list(avg = mean, max = max, min = min, med = median, sd = sd, cumulative = sum), na.rm = T)
# 
# 
# avg.var.names <-  paste0(pos.or.neg.cor, '_avg')
# 
# stateCovid.summary %>%   
#   gather(avg.var.names, key = 'var', value = 'val') %>% 
#   filter(!is.na(val) & !is.na(recovered_avg)) %>% 
#   select(state, var, val, recovered_avg) %>% 
#   ggplot(aes(y = recovered_avg, x = val)) +
#   facet_wrap(~ var, scales = 'free') + 
#   geom_point(aes(color = state)) + 
#   geom_smooth(method = 'lm')
# 
# 
# stateCovid.summary %>%   
#   gather(avg.var.names, key = 'var', value = 'val') %>% 
#   filter(!is.na(val) & !is.na(recovered_avg) & state == 'NY') %>% 
#   select(state, var, val, recovered_avg) %>% 
#   ggplot(aes(y = recovered_avg, x = val)) +
#   facet_wrap(~ var, scales = 'free') + 
#   geom_point(aes(color = state)) + 
#   geom_smooth(method = 'lm')
# 
# 
# heatmap(!is.na(stateCovid.summary), col = col)
# 
# getwd()
# 
# #write_csv(stateCovid.summary,'covidSummary.csv')
# 
# 
# # CORRELLATION DATA AND PLOT
# 
# cumul.var.names <-  paste0(pos.or.neg.cor, '_cumulative')
# 
# stateCovid.summary %>%   
#   gather(cumul.var.names, key = 'var', value = 'val') %>% 
#   filter(!is.na(val) & !is.na(recovered_cumulative)) %>% 
#   select(state, var, val, recovered_cumulative) %>% 
#   ggplot(aes(y = recovered_cumulative, x = val)) +
#   facet_wrap(~ var, scales = 'free') + 
#   geom_point(aes(color = state)) + 
#   geom_smooth(method = 'lm')
# 
# 
# res <- 
#   stateCovid.summary %>% ungroup() %>%  filter(recovered_cumulative > 0) %>% select(cumul.var.names,recovered_cumulative) %>% 
#   cor(use = 'pairwise.complete.obs')
# 
# res[is.na(res)] <- 0
# 
# col<- colorRampPalette(c("blue", "white", "red"))(20)
# heatmap(x = res, col = col, symm = TRUE)
# 
# potential <- res['recovered_cumulative',(res[,"recovered_cumulative"]<1) & 
#                    ((res[,'recovered_cumulative'] > 0.5) | 
#                       (res[,'recovered_cumulative'] < -0.5))]
# 
# cor.var.cumul <- names(potential)
# 
# stateCovid.summary %>% ungroup() %>% 
#   gather(cor.var.cumul, key = 'var', value = 'val') %>% 
#   filter(!is.na(val) & !is.na(recovered_cumulative)) %>% 
#   select(state, var, val, recovered_cumulative) %>% 
#   ggplot(aes(y = recovered_cumulative, x = val)) +
#   facet_wrap(~ var, scales = 'free') + 
#   geom_point(aes(color = state)) + 
#   geom_smooth(method = 'lm')
# 
# stateCovid.summary %>% ungroup() %>% 
#   gather(cor.var.cumul, key = 'var', value = 'val') %>% 
#   filter(!is.na(val) & !is.na(recovered_cumulative)) %>% 
#   select(state, var, val, recovered_cumulative) %>% 
#   ggplot(aes(y = recovered_cumulative, x = val)) +
#   facet_wrap(~ var, scales = 'free') + 
#   geom_point(aes(color = I('royalblue4'))) + 
#   geom_smooth(method = 'lm')
#    
# 
# 
# 
# 
# 
# 








# ###################################################
# #          Full population regressions            #
# ###################################################
# 
# 
# 
# 
# # WITHOUT STATE DATA AVG POOLED STATES      
# Covid.avg.mon <- 
#   stateCovid %>% group_by(month) %>% 
#   summarise_if(is.numeric, list(avg = mean), 
#                na.rm = T)
# 
# 
# 
# res.sum <- 
#   Covid.avg.mon %>% 
#   ungroup() %>% 
#   select(where(is.numeric)) %>% 
#   cor(use = 'pairwise.complete.obs')
# 
# res.sum[is.na(res.sum)] <- 0
# res.sum[is.infinite(res.sum)] <- 1
# 
# col<- colorRampPalette(c("blue", "white", "red"))(20)
# heatmap(x = res.sum, col = col, symm = TRUE, main = 'Correlation heatmap of mean values by month')
# 
# potential_avg <- res.sum['recovered_avg',(res.sum[,'recovered_avg'] < 1) & 
#                            (res.sum[,'recovered_avg'] > 0.5 | 
#                               res.sum[,'recovered_avg'] < -0.5)]
# 
# pot.avg.names <-names(potential_avg)
# 
# 
# Covid.avg.mon %>%  ungroup() %>% 
#   gather(pot.avg.names, key = 'var', value = 'val') %>% 
#   filter(!is.na(val) & !is.na(recovered_avg)) %>% 
#   select(var, val, recovered_avg) %>% 
#   ggplot(aes(y = recovered_avg, x = val)) +
#   facet_wrap(~ var, scales = 'free') + 
#   geom_point(aes(color = I('royalblue4'))) + 
#   geom_smooth(method = 'lm') +
#   labs(title = 'Linear regression plots of mean values by month')
# 
# 
# avg.pooled.rsq <- get.rsq(Covid.avg.mon,pot.avg.names,'_avg')
# 
# avg.pooled.rsq %>% 
#   gather(names(avg.pooled.rsq), key = 'key', value = 'val') %>%  
#   ggplot(aes(x = key, y = val,fill=I('coral3'))) +
#   geom_col() +  coord_flip() +
#   labs(title = 'R squared values (avg by month)')
# 
# 
# # WITHOUT STATE DATA CUMULATIVE POOLED STATES   
# 
# Covid.cumul.mon <- 
#   stateCovid %>% group_by(month) %>% 
#   summarise_if(is.numeric, list(cumulative = sum), 
#                na.rm = T)
# 
# 
# 
# res.sum <- 
#   Covid.cumul.mon %>% 
#   ungroup() %>% 
#   select(where(is.numeric)) %>% 
#   cor(use = 'pairwise.complete.obs')
# 
# res.sum[is.na(res.sum)] <- 0
# res.sum[is.infinite(res.sum)] <- 1
# 
# col<- colorRampPalette(c("blue", "white", "red"))(20)
# heatmap(x = res.sum, col = col, symm = TRUE, main = 'Correlation heatmap of cumulative values by month')
# 
# potential_cumul <- res.sum['recovered_cumulative',(res.sum[,'recovered_cumulative'] < 1) & 
#                            (res.sum[,'recovered_cumulative'] > 0.5 | 
#                               res.sum[,'recovered_cumulative'] < -0.5)]
# 
# pot.cumul.names <-names(potential_cumul)
# 
# 
# Covid.cumul.mon %>%  ungroup() %>% 
#   gather(pot.cumul.names, key = 'var', value = 'val') %>% 
#   filter(!is.na(val) & !is.na(recovered_cumulative)) %>% 
#   select(var, val, recovered_cumulative) %>% 
#   ggplot(aes(y = recovered_cumulative, x = val)) +
#   facet_wrap(~ var, scales = 'free') + 
#   geom_point(aes(color = I('royalblue4'))) + 
#   geom_smooth(method = 'lm') +
#   labs(title = 'Linear regression plots of cumulative values by month')
# 
# cumul.pooled.rsq <- get.rsq(Covid.cumul.mon,pot.cumul.names,'_cumulative')
# 
# cumul.pooled.rsq %>% 
#   gather(names(cumul.pooled.rsq), key = 'key', value = 'val') %>%  
#   ggplot(aes(x = key, y = val,fill=I('darkslategray4'))) +
#   geom_col() + coord_flip() +
#   labs(title = 'R squared values (cumulative by month)')
# 
# # WITHOUT STATE DATA CUMULATIVE POOLED STATES   
# 
# Covid.med.mon <- 
#   stateCovid %>% group_by(month) %>% 
#   summarise_if(is.numeric, list(med = median), 
#                na.rm = T)
# 
# 
# 
# res.sum <- 
#   Covid.med.mon %>% 
#   ungroup() %>% 
#   select(where(is.numeric)) %>% 
#   cor(use = 'pairwise.complete.obs')
# 
# res.sum[is.na(res.sum)] <- 0
# res.sum[is.infinite(res.sum)] <- 1
# 
# col<- colorRampPalette(c("blue", "white", "red"))(20)
# heatmap(x = res.sum, col = col, symm = TRUE, main = 'Correlation heatmap of median values by month')
# 
# potential_med <- res.sum['recovered_med',(res.sum[,'recovered_med'] < 1) & 
#                              (res.sum[,'recovered_med'] > 0.5 | 
#                                 res.sum[,'recovered_med'] < -0.5)]
# 
# pot.med.names <-names(potential_med)
# 
# 
# Covid.med.mon %>%  ungroup() %>% 
#   gather(pot.med.names, key = 'var', value = 'val') %>% 
#   filter(!is.na(val) & !is.na(recovered_med)) %>% 
#   select(var, val, recovered_med) %>% 
#   ggplot(aes(y = recovered_med, x = val)) +
#   facet_wrap(~ var, scales = 'free') + 
#   geom_point(aes(color = I('royalblue4'))) + 
#   geom_smooth(method = 'lm') +
#   labs(title = 'Linear regression plots of median values by month')
# 
# 
# med.pooled.rsq <- get.rsq(Covid.med.mon,pot.med.names,'_med')
# 
# med.pooled.rsq %>% 
#   gather(names(med.pooled.rsq), key = 'key', value = 'val') %>%  
#   ggplot(aes(x = key, y = val,fill=I('dodgerblue2'))) +
#   geom_col() + coord_flip() +
#   labs(title = 'R squared values (median by month)')
# 










###################################################
#          Full population regressions            #
###################################################




# WITHOUT STATE DATA AVG POOLED STATES      
Covid.avg.wk <- 
  stateCovid %>% group_by(week) %>% 
  summarise_if(is.numeric, list(avg = mean), 
               na.rm = T)

summary(Covid.avg.wk$recovered_avg)


res.sum <- 
  Covid.avg.wk %>% 
  ungroup() %>% 
  select(where(is.numeric)) %>% 
  cor(use = 'pairwise.complete.obs')

res.sum[is.na(res.sum)] <- 0
res.sum[is.infinite(res.sum)] <- 1

col<- colorRampPalette(c("blue", "white", "red"))(20)
heatmap(x = res.sum, col = col, symm = TRUE, main = 'Correlation heatmap of mean values by week')

potential_avg <- res.sum['recovered_avg',(res.sum[,'recovered_avg'] < 1) & 
                           (res.sum[,'recovered_avg'] > 0.5 | 
                              res.sum[,'recovered_avg'] < -0.5)]

pot.avg.names <-names(potential_avg)


Covid.avg.wk %>%  ungroup() %>% 
  gather(pot.avg.names, key = 'var', value = 'val') %>% 
  filter(!is.na(val) & !is.na(recovered_avg)) %>% 
  select(var, val, recovered_avg) %>% 
  ggplot(aes(y = recovered_avg, x = val)) +
  facet_wrap(~ var, scales = 'free') + 
  geom_point(aes(color = I('royalblue4'))) + 
  geom_smooth(method = 'lm') +
  labs(title = 'Linear regression plots of mean values by week')


avg.pooled.rsq <- get.rsq(Covid.avg.wk,pot.avg.names,'_avg')

avg.pooled.rsq %>% 
  gather(names(avg.pooled.rsq), key = 'key', value = 'val') %>%  
  ggplot(aes(x = key, y = val,fill=I('coral3'))) +
  geom_col() +  coord_flip() +
  labs(title = 'R squared values (avg by week)')


# WITHOUT STATE DATA CUMULATIVE POOLED STATES   

Covid.cumul.wk <- 
  stateCovid %>% group_by(week) %>% 
  summarise_if(is.numeric, list(cumulative = sum), 
               na.rm = T)



res.sum <- 
  Covid.cumul.wk %>% 
  ungroup() %>% 
  select(where(is.numeric)) %>% 
  cor(use = 'pairwise.complete.obs')

res.sum[is.na(res.sum)] <- 0
res.sum[is.infinite(res.sum)] <- 1

col<- colorRampPalette(c("blue", "white", "red"))(20)
heatmap(x = res.sum, col = col, symm = TRUE, main = 'Correlation heatmap of cumulative values by week')

potential_cumul <- res.sum['recovered_cumulative',(res.sum[,'recovered_cumulative'] < 1) & 
                             (res.sum[,'recovered_cumulative'] > 0.5 | 
                                res.sum[,'recovered_cumulative'] < -0.5)]

pot.cumul.names <-names(potential_cumul)


Covid.cumul.wk %>%  ungroup() %>% 
  gather(pot.cumul.names, key = 'var', value = 'val') %>% 
  filter(!is.na(val) & !is.na(recovered_cumulative)) %>% 
  select(var, val, recovered_cumulative) %>% 
  ggplot(aes(y = recovered_cumulative, x = val)) +
  facet_wrap(~ var, scales = 'free') + 
  geom_point(aes(color = I('royalblue4'))) + 
  geom_smooth(method = 'lm') +
  labs(title = 'Linear regression plots of cumulative values by week')

cumul.pooled.rsq <- get.rsq(Covid.cumul.wk,pot.cumul.names,'_cumulative')

cumul.pooled.rsq %>% 
  gather(names(cumul.pooled.rsq), key = 'key', value = 'val') %>%  
  ggplot(aes(x = key, y = val,fill=I('darkslategray4'))) +
  geom_col() + coord_flip() +
  labs(title = 'R squared values (cumulative by week)')

# WITHOUT STATE DATA CUMULATIVE POOLED STATES   

Covid.med.wk <- 
  stateCovid %>% group_by(week) %>% 
  summarise_if(is.numeric, list(med = median), 
               na.rm = T)



res.sum <- 
  Covid.med.wk %>% 
  ungroup() %>% 
  select(where(is.numeric)) %>% 
  cor(use = 'pairwise.complete.obs')

res.sum[is.na(res.sum)] <- 0
res.sum[is.infinite(res.sum)] <- 1

col<- colorRampPalette(c("blue", "white", "red"))(20)
heatmap(x = res.sum, col = col, symm = TRUE, main = 'Correlation heatmap of median values by week')

potential_med <- res.sum['recovered_med',(res.sum[,'recovered_med'] < 1) & 
                           (res.sum[,'recovered_med'] > 0.5 | 
                              res.sum[,'recovered_med'] < -0.5)]

pot.med.names <-names(potential_med)


Covid.med.wk %>%  ungroup() %>% 
  gather(pot.med.names, key = 'var', value = 'val') %>% 
  filter(!is.na(val) & !is.na(recovered_med)) %>% 
  select(var, val, recovered_med) %>% 
  ggplot(aes(y = recovered_med, x = val)) +
  facet_wrap(~ var, scales = 'free') + 
  geom_point(aes(color = I('royalblue4'))) + 
  geom_smooth(method = 'lm') +
  labs(title = 'Linear regression plots of median values by week')


med.pooled.rsq <- get.rsq(Covid.med.wk,pot.med.names,'_med')

med.pooled.rsq %>% 
  gather(names(med.pooled.rsq), key = 'key', value = 'val') %>%  
  ggplot(aes(x = key, y = val,fill=I('dodgerblue2'))) +
  geom_col() + coord_flip() +
  labs(title = 'R squared values (median by week)')

















###################################################
#         Most recent data regressions            #
###################################################




# WITHOUT STATE DATA AVG MOST RECENT BY STATE      
Covid.avg.recent <- 
  stateCovid %>% 
  filter(month == 10) %>% 
  group_by(state) %>% 
  summarise_if(is.numeric, list(avg = mean), 
               na.rm = T)


res.sum <- 
  Covid.avg.recent %>% 
  ungroup() %>% 
  select(where(is.numeric)) %>% 
  cor(use = 'pairwise.complete.obs')

res.sum[is.na(res.sum)] <- 0
res.sum[is.infinite(res.sum)] <- 1

col<- colorRampPalette(c("blue", "white", "red"))(20)
heatmap(x = res.sum, col = col, symm = TRUE, main = 'Correlation heatmap of most recent mean values by state')

potential_avg <- res.sum['recovered_avg',(res.sum[,'recovered_avg'] < 1) & 
                           (res.sum[,'recovered_avg'] > 0.5 | 
                              res.sum[,'recovered_avg'] < -0.5)]

pot.avg.names <-names(potential_avg)


Covid.avg.recent %>%  ungroup() %>% 
  gather(pot.avg.names, key = 'var', value = 'val') %>% 
  filter(!is.na(val) & !is.na(recovered_avg)) %>% 
  select(var, val, recovered_avg) %>% 
  ggplot(aes(y = recovered_avg, x = val)) +
  facet_wrap(~ var, scales = 'free') + 
  geom_point(aes(color = I('royalblue4'))) + 
  geom_smooth(method = 'lm') +
  labs(title = 'Linear regression plots of most recent mean values by state')

avg.recent.rsq <- get.rsq(Covid.avg.recent,pot.avg.names,'_avg')

avg.recent.rsq %>% 
  gather(names(avg.recent.rsq), key = 'key', value = 'val') %>%  
  ggplot(aes(x = key, y = val,fill=I('coral3'))) +
  geom_col() + coord_flip()  +
  labs(title = 'R squared values (most recent mean by state)')

# WITHOUT STATE DATA CUMULATIVE MOST RECENT BY STATE  

Covid.cumul.recent <- 
  stateCovid %>% 
  filter (month == 10) %>% 
  group_by(state) %>% 
  summarise_if(is.numeric, list(cumulative = sum), 
               na.rm = T)



res.sum <- 
  Covid.cumul.recent %>% 
  ungroup() %>% 
  select(where(is.numeric)) %>% 
  cor(use = 'pairwise.complete.obs')

res.sum[is.na(res.sum)] <- 0
res.sum[is.infinite(res.sum)] <- 1

col<- colorRampPalette(c("blue", "white", "red"))(20)
heatmap(x = res.sum, col = col, symm = TRUE, main = 'Correlation heatmap of most recent cumulative values by state')

potential_cumul <- res.sum['recovered_cumulative',(res.sum[,'recovered_cumulative'] < 1) & 
                             (res.sum[,'recovered_cumulative'] > 0.5 | 
                                res.sum[,'recovered_cumulative'] < -0.5)]

pot.cumul.names <-names(potential_cumul)


Covid.cumul.recent %>%  ungroup() %>% 
  gather(pot.cumul.names, key = 'var', value = 'val') %>% 
  filter(!is.na(val) & !is.na(recovered_cumulative)) %>% 
  select(var, val, recovered_cumulative) %>% 
  ggplot(aes(y = recovered_cumulative, x = val)) +
  facet_wrap(~ var, scales = 'free') + 
  geom_point(aes(color = I('royalblue4'))) + 
  geom_smooth(method = 'lm') +
  labs(title = 'Linear regression plots of most recent cumulative values by state')

cumul.recent.rsq <- get.rsq(Covid.cumul.recent,pot.cumul.names,'_cumulative')

cumul.recent.rsq %>% 
  gather(names(cumul.recent.rsq), key = 'key', value = 'val') %>%  
  ggplot(aes(x = key, y = val,fill=I('darkslategray4'))) +
  geom_col() + coord_flip()  +
  labs(title = 'R squared values (most recent cumulative by state)')

# WITHOUT STATE DATA CUMULATIVE MOST RECENT BY STATE    

Covid.med.recent <- 
  stateCovid %>% 
  filter(month == 10) %>% 
  group_by(state) %>% 
  summarise_if(is.numeric, list(med = median), 
               na.rm = T)

res.sum <- 
  Covid.med.recent %>% 
  ungroup() %>% 
  select(where(is.numeric)) %>% 
  cor(use = 'pairwise.complete.obs')

res.sum[is.na(res.sum)] <- 0
res.sum[is.infinite(res.sum)] <- 1

col<- colorRampPalette(c("blue", "white", "red"))(20)
heatmap(x = res.sum, col = col, symm = TRUE, main = 'Correlation heatmap of most recent median values by state')

potential_med <- res.sum['recovered_med',(res.sum[,'recovered_med'] < 1) & 
                           (res.sum[,'recovered_med'] > 0.5 | 
                              res.sum[,'recovered_med'] < -0.5)]

pot.med.names <-names(potential_med)


Covid.med.recent %>%  ungroup() %>% 
  gather(pot.med.names, key = 'var', value = 'val') %>% 
  filter(!is.na(val) & !is.na(recovered_med)) %>% 
  select(var, val, recovered_med) %>% 
  ggplot(aes(y = recovered_med, x = val)) +
  facet_wrap(~ var, scales = 'free') + 
  geom_point(aes(color = I('royalblue4'))) + 
  geom_smooth(method = 'lm') +
  labs(title = 'Linear regression plots of most recent median values by state')


med.recent.rsq <- get.rsq(Covid.med.recent,pot.med.names,'_med')

med.recent.rsq %>% 
  gather(names(med.recent.rsq), key = 'key', value = 'val') %>%  
  ggplot(aes(x = key, y = val,fill=I('dodgerblue2'))) +
  geom_col() + coord_flip()  +
  labs(title = 'R squared values (most recent median by state)')




for (x in )

oct <- stateCovid %>% filter(month == 10)


state.valCount.oct <- list() 
  for (st in states) {
    temp <- oct %>% filter(state == st)
    state.valCount.oct[[st]] <- length(temp[,1])
  }


sept <- stateCovid %>% filter(month == 9)


state.valCount.sept <- list() 
for (st in states) {
  temp <- sept %>% filter(state == st)
  state.valCount.sept[[st]] <- length(temp[,1])
}











###################################################
#          Using the reduced dataset              #
###################################################


# ALTERNATIVE DATASET
variables <-  names(stateCovid)
n <- length(stateCovid[,1])
sel <-  vector()
for (v in variables) {
  col <- stateCovid %>% filter(!is.na(stateCovid[,v]) & month > 1 & month < 11)
  c <- length(col[,v])
  if (c/n > 0.75) {
    sel <- append(sel, v)
  }
}

stateCovid2 <- stateCovid %>% filter(month > 1 & month < 11) %>% select(all_of(sel))





###################################################
#          Full population regressions            #
###################################################




# WITHOUT STATE DATA AVG POOLED STATES      
Covid.avg.mon <- 
  stateCovid2 %>% group_by(month) %>% 
  summarise_if(is.numeric, list(avg = mean), 
               na.rm = T)



res.sum <- 
  Covid.avg.mon %>% 
  ungroup() %>% 
  select(where(is.numeric)) %>% 
  cor(use = 'pairwise.complete.obs')

res.sum[is.na(res.sum)] <- 0
res.sum[is.infinite(res.sum)] <- 1

col<- colorRampPalette(c("blue", "white", "red"))(20)
heatmap(x = res.sum, col = col, symm = TRUE, main = 'Correlation heatmap of mean values by month')

potential_avg <- res.sum['recovered_avg',(res.sum[,'recovered_avg'] < 1) & 
                           (res.sum[,'recovered_avg'] > 0.5 | 
                              res.sum[,'recovered_avg'] < -0.5)]

pot.avg.names <-names(potential_avg)


Covid.avg.mon %>%  ungroup() %>% 
  gather(pot.avg.names, key = 'var', value = 'val') %>% 
  filter(!is.na(val) & !is.na(recovered_avg)) %>% 
  select(var, val, recovered_avg) %>% 
  ggplot(aes(y = recovered_avg, x = val)) +
  facet_wrap(~ var, scales = 'free') + 
  geom_point(aes(color = I('royalblue4'))) + 
  geom_smooth(method = 'lm') +
  labs(title = 'Linear regression plots of mean values by month')


avg.pooled.rsq <- get.rsq(Covid.avg.mon,pot.avg.names,'_avg')

avg.pooled.rsq %>% 
  gather(names(avg.pooled.rsq), key = 'key', value = 'val') %>%  
  ggplot(aes(x = key, y = val,fill=I('coral3'))) +
  geom_col() +  coord_flip() +
  labs(title = 'R squared values (avg by month)')


# WITHOUT STATE DATA CUMULATIVE POOLED STATES   

Covid.cumul.mon <- 
  stateCovid2 %>% group_by(month) %>% 
  summarise_if(is.numeric, list(cumulative = sum), 
               na.rm = T)



res.sum <- 
  Covid.cumul.mon %>% 
  ungroup() %>% 
  select(where(is.numeric)) %>% 
  cor(use = 'pairwise.complete.obs')

res.sum[is.na(res.sum)] <- 0
res.sum[is.infinite(res.sum)] <- 1

col<- colorRampPalette(c("blue", "white", "red"))(20)
heatmap(x = res.sum, col = col, symm = TRUE, main = 'Correlation heatmap of cumulative values by month')

potential_cumul <- res.sum['recovered_cumulative',(res.sum[,'recovered_cumulative'] < 1) & 
                             (res.sum[,'recovered_cumulative'] > 0.5 | 
                                res.sum[,'recovered_cumulative'] < -0.5)]

pot.cumul.names <-names(potential_cumul)


Covid.cumul.mon %>%  ungroup() %>% 
  gather(pot.cumul.names, key = 'var', value = 'val') %>% 
  filter(!is.na(val) & !is.na(recovered_cumulative)) %>% 
  select(var, val, recovered_cumulative) %>% 
  ggplot(aes(y = recovered_cumulative, x = val)) +
  facet_wrap(~ var, scales = 'free') + 
  geom_point(aes(color = I('royalblue4'))) + 
  geom_smooth(method = 'lm') +
  labs(title = 'Linear regression plots of cumulative values by month')

cumul.pooled.rsq <- get.rsq(Covid.cumul.mon,pot.cumul.names,'_cumulative')

cumul.pooled.rsq %>% 
  gather(names(cumul.pooled.rsq), key = 'key', value = 'val') %>%  
  ggplot(aes(x = key, y = val,fill=I('darkslategray4'))) +
  geom_col() + coord_flip() +
  labs(title = 'R squared values (cumulative by month)')

# WITHOUT STATE DATA CUMULATIVE POOLED STATES   

Covid.med.mon <- 
  stateCovid2 %>% group_by(month) %>% 
  summarise_if(is.numeric, list(med = median), 
               na.rm = T)



res.sum <- 
  Covid.med.mon %>% 
  ungroup() %>% 
  select(where(is.numeric)) %>% 
  cor(use = 'pairwise.complete.obs')

res.sum[is.na(res.sum)] <- 0
res.sum[is.infinite(res.sum)] <- 1

col<- colorRampPalette(c("blue", "white", "red"))(20)
heatmap(x = res.sum, col = col, symm = TRUE, main = 'Correlation heatmap of median values by month')

potential_med <- res.sum['recovered_med',(res.sum[,'recovered_med'] < 1) & 
                           (res.sum[,'recovered_med'] > 0.5 | 
                              res.sum[,'recovered_med'] < -0.5)]

pot.med.names <-names(potential_med)


Covid.med.mon %>%  ungroup() %>% 
  gather(pot.med.names, key = 'var', value = 'val') %>% 
  filter(!is.na(val) & !is.na(recovered_med)) %>% 
  select(var, val, recovered_med) %>% 
  ggplot(aes(y = recovered_med, x = val)) +
  facet_wrap(~ var, scales = 'free') + 
  geom_point(aes(color = I('royalblue4'))) + 
  geom_smooth(method = 'lm') +
  labs(title = 'Linear regression plots of median values by month')


med.pooled.rsq <- get.rsq(Covid.med.mon,pot.med.names,'_med')

med.pooled.rsq %>% 
  gather(names(med.pooled.rsq), key = 'key', value = 'val') %>%  
  ggplot(aes(x = key, y = val,fill=I('dodgerblue2'))) +
  geom_col() + coord_flip() +
  labs(title = 'R squared values (median by month)')


###################################################
#         Most recent data regressions            #
###################################################




# WITHOUT STATE DATA AVG MOST RECENT BY STATE      
Covid.avg.recent <- 
  stateCovid2 %>% 
  filter(month == 10) %>% 
  group_by(state) %>% 
  summarise_if(is.numeric, list(avg = mean), 
               na.rm = T)


res.sum <- 
  Covid.avg.recent %>% 
  ungroup() %>% 
  select(where(is.numeric)) %>% 
  cor(use = 'pairwise.complete.obs')

res.sum[is.na(res.sum)] <- 0
res.sum[is.infinite(res.sum)] <- 1

col<- colorRampPalette(c("blue", "white", "red"))(20)
heatmap(x = res.sum, col = col, symm = TRUE, main = 'Correlation heatmap of most recent mean values by state')

potential_avg <- res.sum['recovered_avg',(res.sum[,'recovered_avg'] < 1) & 
                           (res.sum[,'recovered_avg'] > 0.5 | 
                              res.sum[,'recovered_avg'] < -0.5)]

pot.avg.names <-names(potential_avg)


Covid.avg.recent %>%  ungroup() %>% 
  gather(pot.avg.names, key = 'var', value = 'val') %>% 
  filter(!is.na(val) & !is.na(recovered_avg)) %>% 
  select(var, val, recovered_avg) %>% 
  ggplot(aes(y = recovered_avg, x = val)) +
  facet_wrap(~ var, scales = 'free') + 
  geom_point(aes(color = I('royalblue4'))) + 
  geom_smooth(method = 'lm') +
  labs(title = 'Linear regression plots of most recent mean values by state')

avg.recent.rsq <- get.rsq(Covid.avg.recent,pot.avg.names,'_avg')

avg.recent.rsq %>% 
  gather(names(avg.recent.rsq), key = 'key', value = 'val') %>%  
  ggplot(aes(x = key, y = val,fill=I('coral3'))) +
  geom_col() + coord_flip()  +
  labs(title = 'R squared values (most recent mean by state)')

# WITHOUT STATE DATA CUMULATIVE MOST RECENT BY STATE  

Covid.cumul.recent <- 
  stateCovid2 %>% 
  filter (month == 10) %>% 
  group_by(state) %>% 
  summarise_if(is.numeric, list(cumulative = sum), 
               na.rm = T)



res.sum <- 
  Covid.cumul.recent %>% 
  ungroup() %>% 
  select(where(is.numeric)) %>% 
  cor(use = 'pairwise.complete.obs')

res.sum[is.na(res.sum)] <- 0
res.sum[is.infinite(res.sum)] <- 1

col<- colorRampPalette(c("blue", "white", "red"))(20)
heatmap(x = res.sum, col = col, symm = TRUE, main = 'Correlation heatmap of most recent cumulative values by state')

potential_cumul <- res.sum['recovered_cumulative',(res.sum[,'recovered_cumulative'] < 1) & 
                             (res.sum[,'recovered_cumulative'] > 0.5 | 
                                res.sum[,'recovered_cumulative'] < -0.5)]

pot.cumul.names <-names(potential_cumul)


Covid.cumul.recent %>%  ungroup() %>% 
  gather(pot.cumul.names, key = 'var', value = 'val') %>% 
  filter(!is.na(val) & !is.na(recovered_cumulative)) %>% 
  select(var, val, recovered_cumulative) %>% 
  ggplot(aes(y = recovered_cumulative, x = val)) +
  facet_wrap(~ var, scales = 'free') + 
  geom_point(aes(color = I('royalblue4'))) + 
  geom_smooth(method = 'lm') +
  labs(title = 'Linear regression plots of most recent cumulative values by state')

cumul.recent.rsq <- get.rsq(Covid.cumul.recent,pot.cumul.names,'_cumulative')

cumul.recent.rsq %>% 
  gather(names(cumul.recent.rsq), key = 'key', value = 'val') %>%  
  ggplot(aes(x = key, y = val,fill=I('darkslategray4'))) +
  geom_col() + coord_flip()  +
  labs(title = 'R squared values (most recent cumulative by state)')

# WITHOUT STATE DATA CUMULATIVE MOST RECENT BY STATE    

Covid.med.recent <- 
  stateCovid2 %>% 
  filter(month == 10) %>% 
  group_by(state) %>% 
  summarise_if(is.numeric, list(med = median), 
               na.rm = T)

res.sum <- 
  Covid.med.recent %>% 
  ungroup() %>% 
  select(where(is.numeric)) %>% 
  cor(use = 'pairwise.complete.obs')

res.sum[is.na(res.sum)] <- 0
res.sum[is.infinite(res.sum)] <- 1

col<- colorRampPalette(c("blue", "white", "red"))(20)
heatmap(x = res.sum, col = col, symm = TRUE, main = 'Correlation heatmap of most recent median values by state')

potential_med <- res.sum['recovered_med',(res.sum[,'recovered_med'] < 1) & 
                           (res.sum[,'recovered_med'] > 0.5 | 
                              res.sum[,'recovered_med'] < -0.5)]

pot.med.names <-names(potential_med)


Covid.med.recent %>%  ungroup() %>% 
  gather(pot.med.names, key = 'var', value = 'val') %>% 
  filter(!is.na(val) & !is.na(recovered_med)) %>% 
  select(var, val, recovered_med) %>% 
  ggplot(aes(y = recovered_med, x = val)) +
  facet_wrap(~ var, scales = 'free') + 
  geom_point(aes(color = I('royalblue4'))) + 
  geom_smooth(method = 'lm') +
  labs(title = 'Linear regression plots of most recent median values by state')


med.recent.rsq <- get.rsq(Covid.med.recent,pot.med.names,'_med')

med.recent.rsq %>% 
  gather(names(med.recent.rsq), key = 'key', value = 'val') %>%  
  ggplot(aes(x = key, y = val,fill=I('dodgerblue2'))) +
  geom_col() + coord_flip()  +
  labs(title = 'R squared values (most recent median by state)')


