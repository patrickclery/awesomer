'use client';

import {
  LineChart,
  Line,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ResponsiveContainer,
} from 'recharts';

interface StarChartProps {
  data: Array<{ snapshotDate: string; stars: number }>;
}

export default function StarChart({ data }: StarChartProps) {
  if (data.length < 2) return null;

  return (
    <div className="mb-8">
      <h2 className="text-lg font-semibold mb-4">Star History</h2>
      <div className="p-4 bg-surface border border-border rounded-lg">
        <ResponsiveContainer width="100%" height={300}>
          <LineChart data={data}>
            <CartesianGrid strokeDasharray="3 3" stroke="#262626" />
            <XAxis
              dataKey="snapshotDate"
              tick={{ fill: '#737373', fontSize: 12 }}
              tickFormatter={(value: string) =>
                new Date(value).toLocaleDateString('en-US', {
                  month: 'short',
                  day: 'numeric',
                })
              }
            />
            <YAxis
              tick={{ fill: '#737373', fontSize: 12 }}
              tickFormatter={(value: number) =>
                value >= 1000 ? `${(value / 1000).toFixed(1)}k` : String(value)
              }
            />
            <Tooltip
              contentStyle={{
                backgroundColor: '#141414',
                border: '1px solid #262626',
                borderRadius: '8px',
                color: '#ededed',
              }}
              labelFormatter={(label) =>
                new Date(String(label)).toLocaleDateString()
              }
              formatter={(value) => [
                Number(value).toLocaleString(),
                'Stars',
              ]}
            />
            <Line
              type="monotone"
              dataKey="stars"
              stroke="#3b82f6"
              strokeWidth={2}
              dot={false}
            />
          </LineChart>
        </ResponsiveContainer>
      </div>
    </div>
  );
}
