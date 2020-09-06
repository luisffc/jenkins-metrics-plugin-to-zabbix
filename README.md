# Monitoring Jenkins using Metrics Plugin and Zabbix

## This solution is composed by three parts
 1. Jenkins' [Metrics Plugin](https://wiki.jenkins-ci.org/display/JENKINS/Metrics+Plugin)
 2. A python script, which gets metrics from above plugin and transform it in a readable Zabbix item.
 3. A Zabbix Agentd config file which runs the above script and sends result to  Zabbix server

## Install
1. First install Jenkins' [Metrics Plugin](https://wiki.jenkins-ci.org/display/JENKINS/Metrics+Plugin) and create a access key.
2. Put Jenkins’ URL and access key into `jenkins-metrics.py`
3. Move `jenkins-metrics.py` and `jenkins_zabbix.conf` to Jenkins master instance.
4. Move `jenkins_zabbix.conf` to /etc/zabbix/zabbix_agentd.conf.d
5. Move `jenkins-metrics.py` to /usr/local/bin/
6. Make sure you have `python v 2` Installed 
7. Restart `zabbix-agent` service 
8. login to your Zabbix admin panel and import `zabbix5 jenkins template.xml` to `Configuration > Templates` 

---

## Appendix
### Further Reading
Take another look at Jenkins' [Metrics Plugin](https://wiki.jenkins-ci.org/display/JENKINS/Metrics+Plugin) to know more about these metrics and start creating items in Zabbix server

### How to generate your own template
You can use the bash scripts provided by `Mohammadmahmoud Agahi` to create your own customized template:
1. On the Jenkins master node open a terminal and enter this command:
        `python2 /usr/local/bin/jenkins-metrics.py | sort -u > ~/raw_jenkins_metric_data.txt`
2. Look at the file get familiar with the keys
3. edit the `make-template.sh` and edit it to fit your needs
4. On the Jenkins master node open a terminal and enter this command: 
        `./make-template.sh ~/raw_jenkins_metric_data.txt > jenkins-template.xml`

### How this python script works
It simply uses Jenkins' [Metrics Plugin](https://wiki.jenkins-ci.org/display/JENKINS/Metrics+Plugin)’s API to get a Json containing metrics and transforms it in a more readable file to Zabbix.

However you can also make use of it without a Zabbix, like shown bellow:

```
python2 jenkins-metrics.py
```

This will return all the metrics at once. If you want to get just one of the metrics, use a full path to a metric item. For example, to get this metric

```
{
  "gauges" : {
    "jenkins.executor.count.value" : {
      "value" : 52
    },
...
```
 
You can type:

```
python2 jenkins-metrics.py gauges.jenkins.executor.count.value.value
```
