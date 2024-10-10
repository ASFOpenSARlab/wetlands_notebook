def test_hyp3_wetlands(script_runner):
    ret = script_runner.run(['python', '-m', 'hyp3_wetlands', '-h'])
    assert ret.success
