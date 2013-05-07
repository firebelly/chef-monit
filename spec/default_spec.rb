require 'spec_helper'

describe 'monit::default' do
  let(:chef_run) { runner.converge 'monit::default' }

  it "creates the monitrc" do
    chef_run.should create_file_with_content "/etc/monit/monitrc", "set alert #{runner.node[:monit][:notify_email]}"

    @runner.node.default[:monit][:email_alerts?] = false
    chef_run.should_not create_file_with_content "/etc/monit/monitrc", "set alert #{runner.node[:monit][:notify_email]}"
  end

  it "creates directory /etc/monit/conf.d/" do
    expect(chef_run).to create_directory '/etc/monit/conf.d/'
  end

end

