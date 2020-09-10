import React from 'react';
import './App.css';
import Form from './view/FormPage';
import { Tabs, Tab } from 'grommet';
import { clubModel, sendClub, randomGenClub } from './viewModel/club';
import { scheduleModel, sendSchedule, randomGenSchedule } from './viewModel/schedule';
import { eventModel, sendEvent, randomGenEvent } from './viewModel/event';

function App() {
  return (
    <div className="App">
      <Tabs>
        <Tab title="団体追加">
          <Form key="1" data={clubModel} onClickSend={sendClub} randomGen={randomGenClub}/>
        </Tab>
        <Tab title="イベント追加">
          <Form key="2" data={eventModel} onClickSend={sendEvent} randomGen={randomGenEvent} />
        </Tab>
        <Tab title="イベントスケジュール追加">
          <Form key="2" data={scheduleModel} onClickSend={sendSchedule} randomGen={randomGenSchedule} />
        </Tab>
      </Tabs>
    </div>
  );
}

export default App;
